import 'package:flutter/material.dart';

import '../viewmodels/auth_viewmodel.dart';
import '../utils/validadores.dart';

class CadastroView extends StatefulWidget {
  final AuthViewModel authViewModel;

  const CadastroView({super.key, required this.authViewModel});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  bool _senhaOculta = true;
  bool _confirmarSenhaOculta = true;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _fazerCadastro() async {
    widget.authViewModel.limparErro();
    if (_formKey.currentState?.validate() ?? false) {
      final sucesso = await widget.authViewModel.cadastrar(
        _nomeController.text,
        _emailController.text,
        _senhaController.text,
      );

      if (!mounted) return;

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Conta criada com sucesso! Você já pode realizar o login.',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        final erro =
            widget.authViewModel.mensagemErro ?? 'Erro ao cadastrar usuário.';
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
      appBar: AppBar(title: const Text('Criar Nova Conta'), elevation: 0),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 24.0,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Cadastre-se',
                      textAlign: TextAlign.center,
                      style: tema.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Preencha as informações para começar a editar documentos',
                      textAlign: TextAlign.center,
                      style: tema.textTheme.bodyMedium?.copyWith(
                        color: tema.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Campo de Nome Completo
                    TextFormField(
                      controller: _nomeController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: Validadores.validarNome,
                      decoration: const InputDecoration(
                        labelText: 'Nome completo',
                        hintText: 'Digite seu nome',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

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
                      textInputAction: TextInputAction.next,
                      validator: Validadores.validarSenha,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        hintText: 'Mínimo de 6 caracteres',
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
                    const SizedBox(height: 16),

                    // Campo de Confirmação de Senha
                    TextFormField(
                      controller: _confirmarSenhaController,
                      obscureText: _confirmarSenhaOculta,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _fazerCadastro(),
                      validator: (valor) => Validadores.validarConfirmacaoSenha(
                        valor,
                        _senhaController.text,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Confirmar Senha',
                        prefixIcon: const Icon(Icons.lock_reset_outlined),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _confirmarSenhaOculta
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _confirmarSenhaOculta = !_confirmarSenhaOculta;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Botão de Cadastrar reativo ao ViewModel
                    ListenableBuilder(
                      listenable: widget.authViewModel,
                      builder: (context, _) {
                        final carregando = widget.authViewModel.isLoading;
                        return ElevatedButton(
                          onPressed: carregando ? null : _fazerCadastro,
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
                                  'Criar Conta',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Retornar ao login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Já possui conta?'),
                        TextButton(
                          onPressed: () {
                            widget.authViewModel.limparErro();
                            Navigator.pop(context);
                          },
                          child: const Text('Fazer Login'),
                        ),
                      ],
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
