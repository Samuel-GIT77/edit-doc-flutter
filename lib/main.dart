import 'package:flutter/material.dart';

import 'models/services/preferences_service.dart';
import 'models/services/banco_local_service.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/documentos_viewmodel.dart';
import 'views/login_view.dart';
import 'views/cadastro_view.dart';
import 'views/home_view.dart';
import 'views/editor_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialização de Serviços e Camada de Acesso a Dados
  final bancoService = BancoLocalService();
  final prefsService = PreferencesService();

  // Inicialização dos ViewModels com injeção de dependências
  final authViewModel = AuthViewModel(
    bancoService: bancoService,
    prefsService: prefsService,
  );

  final documentosViewModel = DocumentosViewModel(bancoService: bancoService);

  // Carrega preferências persistidas (tema e sessão)
  await authViewModel.inicializar();

  runApp(
    EditDocApp(
      authViewModel: authViewModel,
      documentosViewModel: documentosViewModel,
    ),
  );
}

class EditDocApp extends StatelessWidget {
  final AuthViewModel authViewModel;
  final DocumentosViewModel documentosViewModel;

  const EditDocApp({
    super.key,
    required this.authViewModel,
    required this.documentosViewModel,
  });

  @override
  Widget build(BuildContext context) {
    // Reage às mudanças de tema e autenticação do AuthViewModel
    return ListenableBuilder(
      listenable: authViewModel,
      builder: (context, _) {
        return MaterialApp(
          title: 'Editor de Docs',
          debugShowCheckedModeBanner: false,
          themeMode:
              authViewModel.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.indigo,
              brightness: Brightness.light,
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.indigo,
              brightness: Brightness.dark,
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
            ),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => LoginView(authViewModel: authViewModel),
            '/cadastro': (context) =>
                CadastroView(authViewModel: authViewModel),
            '/home': (context) => HomeView(
                  authViewModel: authViewModel,
                  documentosViewModel: documentosViewModel,
                ),
            '/editor': (context) => EditorView(
                  authViewModel: authViewModel,
                  documentosViewModel: documentosViewModel,
                ),
          },
        );
      },
    );
  }
}
