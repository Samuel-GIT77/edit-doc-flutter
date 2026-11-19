import 'package:flutter/material.dart';

import '../viewmodels/auth_viewmodel.dart';
import '../utils/validadores.dart';

class LoginView extends StatefulWidget {
  final AuthViewModel authViewModel;

  const LoginView({super.key, required this.authViewModel});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _senhaOculta = true;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _fazerLogin() async {
    widget.authViewModel.limparErro();
    if (_formKey.currentState?.validate() ?? false) {
      final sucesso = await widget.authViewModel.login(
        _emailController.text,
        _senhaController.text,
      );

      if (!mounted) return;

      if (sucesso) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        final erro =
            widget.authViewModel.mensagemErro ?? 'Erro ao realizar login.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(erro), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.article_outlined,
                      size: 72,
                      color: tema.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Editor de Documentos',
                      textAlign: TextAlign.center,
                      style: tema.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Faça login para gerenciar seus documentos',
                      textAlign: TextAlign.center,
                      style: tema.textTheme.bodyMedium?.copyWith(
                        color: tema.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Campo de E-mail
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: Validadores.validarEmail,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        hintText: 'exemplo@dominio.com',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campo de Senha
                    TextFormField(
                      controller: _senhaController,
                      obscureText: _senhaOculta,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _fazerLogin(),
                      validator: Validadores.validarSenha,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _senhaOculta
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _senhaOculta = !_senhaOculta;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Botão de Login reativo ao ViewModel
                    ListenableBuilder(
                      listenable: widget.authViewModel,
                      builder: (context, _) {
                        final carregando = widget.authViewModel.isLoading;
                        return ElevatedButton(
                          onPressed: carregando ? null : _fazerLogin,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: carregando
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Entrar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Navegação para Cadastro
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Não tem uma conta?'),
                        TextButton(
                          onPressed: () {
                            widget.authViewModel.limparErro();
                            Navigator.pushNamed(context, '/cadastro');
                          },
                          child: const Text('Cadastre-se'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    // Card com credenciais de teste para praticidade
                    Card(
                      elevation: 0,
                      color: tema.colorScheme.surfaceVariant.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '💡 Dica para teste rápido:',
                              style: tema.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'E-mail: admin@exemplo.com\nSenha: 123456',
                              style: tema.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
