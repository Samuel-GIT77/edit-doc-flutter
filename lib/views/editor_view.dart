import 'package:flutter/material.dart';

import '../models/documento.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/documentos_viewmodel.dart';
import '../utils/validadores.dart';

class EditorView extends StatefulWidget {
  final AuthViewModel authViewModel;
  final DocumentosViewModel documentosViewModel;

  const EditorView({
    super.key,
    required this.authViewModel,
    required this.documentosViewModel,
  });

  @override
  State<EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<EditorView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tituloController;
  late final TextEditingController _conteudoController;

  Documento? _documentoOriginal;
  bool _inicializado = false;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController();
    _conteudoController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_inicializado) {
      final doc = ModalRoute.of(context)?.settings.arguments as Documento?;
      if (doc != null) {
        _documentoOriginal = doc;
        _tituloController.text = doc.titulo;
        _conteudoController.text = doc.conteudo;
      }
      _inicializado = true;
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _conteudoController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    widget.documentosViewModel.limparErro();
    if (_formKey.currentState?.validate() ?? false) {
      final autorEmail =
          widget.authViewModel.usuarioAtual?.email ?? 'usuario@local.com';

      final sucesso = await widget.documentosViewModel.salvarDocumento(
        id: _documentoOriginal?.id,
        titulo: _tituloController.text,
        conteudo: _conteudoController.text,
        autorEmail: autorEmail,
      );

      if (!mounted) return;

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _documentoOriginal == null
                  ? 'Documento criado com sucesso!'
                  : 'Documento atualizado com sucesso!',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        final erro = widget.documentosViewModel.mensagemErro ??
            'Falha ao salvar documento.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(erro), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final ehEdicao = _documentoOriginal != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(ehEdicao ? 'Editar Documento' : 'Novo Documento'),
        actions: [
          ListenableBuilder(
            listenable: widget.documentosViewModel,
            builder: (context, _) {
              final salvando = widget.documentosViewModel.isLoading;
              return TextButton.icon(
                onPressed: salvando ? null : _salvar,
                icon: salvando
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check),
                label: const Text(
                  'Salvar',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Título
                TextFormField(
                  controller: _tituloController,
                  validator: Validadores.validarTitulo,
                  style: tema.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Título do Documento',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
                const Divider(),
                // Conteúdo / Corpo
                Expanded(
                  child: TextFormField(
                    controller: _conteudoController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: tema.textTheme.bodyLarge,
                    decoration: const InputDecoration(
                      hintText: 'Digite o conteúdo do seu documento aqui...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
