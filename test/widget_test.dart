import 'package:flutter_test/flutter_test.dart';
import 'package:edit_doc_flutter/main.dart';
import 'package:edit_doc_flutter/models/services/banco_local_service.dart';
import 'package:edit_doc_flutter/models/services/preferences_service.dart';
import 'package:edit_doc_flutter/viewmodels/auth_viewmodel.dart';
import 'package:edit_doc_flutter/viewmodels/documentos_viewmodel.dart';

void main() {
  testWidgets('Verifica renderização da tela inicial de Login',
      (WidgetTester tester) async {
    final bancoService = BancoLocalService();
    final prefsService = PreferencesService();
    final authViewModel = AuthViewModel(
      bancoService: bancoService,
      prefsService: prefsService,
    );
    final documentosViewModel = DocumentosViewModel(
      bancoService: bancoService,
    );

    await tester.pumpWidget(
      EditDocApp(
        authViewModel: authViewModel,
        documentosViewModel: documentosViewModel,
      ),
    );

    expect(find.text('Editor de Documentos'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}
