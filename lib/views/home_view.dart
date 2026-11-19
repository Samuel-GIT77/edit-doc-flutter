import 'package:flutter/material.dart';

import '../models/documento.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/documentos_viewmodel.dart';

class HomeView extends StatefulWidget {
  final AuthViewModel authViewModel;
  final DocumentosViewModel documentosViewModel;

  const HomeView({
    super.key,
    required this.authViewModel,
    required this.documentosViewModel,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final email = widget.authViewModel.usuarioAtual?.email ?? '';
      widget.documentosViewModel.carregarDocumentos(email);
    });
  }

  void _confirmarLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Saída'),
        content: const Text('Deseja realmente sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await widget.authViewModel.logout();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, '/');
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  void _confirmarExclusao(Documento doc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Documento'),
        content: Text(
          'Tem certeza que deseja excluir o documento "${doc.titulo}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              Navigator.pop(ctx);
              final sucesso = await widget.documentosViewModel.excluirDocumento(
                doc.id,
              );
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    sucesso
                        ? 'Documento excluído com sucesso.'
                        : 'Erro ao excluir documento.',
                  ),
                ),
              );
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  String _formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final ano = data.year;
    final hora = data.hour.toString().padLeft(2, '0');
    final min = data.minute.toString().padLeft(2, '0');
    return '$dia/$mes/$ano às $hora:$min';
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final usuario = widget.authViewModel.usuarioAtual;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Meus Documentos',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            if (usuario != null)
              Text(
                'Olá, ${usuario.nome}',
                style: tema.textTheme.bodySmall?.copyWith(
                  color: tema.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        actions: [
          // Alternar Tema (Claro / Escuro)
          ListenableBuilder(
            listenable: widget.authViewModel,
            builder: (context, _) {
              final isDark = widget.authViewModel.isDarkTheme;
              return IconButton(
                tooltip: isDark ? 'Modo Claro' : 'Modo Escuro',
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () => widget.authViewModel.alternarTema(),
              );
            },
          ),
          // Botão Logout
          IconButton(
            tooltip: 'Sair da Conta',
            icon: const Icon(Icons.logout),
            onPressed: _confirmarLogout,
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.documentosViewModel,
        builder: (context, _) {
          if (widget.documentosViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = widget.documentosViewModel.documentos;

          if (docs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.note_add_outlined,
                      size: 80,
                      color: tema.colorScheme.primary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhum documento encontrado',
                      style: tema.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Clique no botão "+" abaixo para criar seu primeiro documento.',
                      textAlign: TextAlign.center,
                      style: tema.textTheme.bodyMedium?.copyWith(
                        color: tema.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              final email = widget.authViewModel.usuarioAtual?.email ?? '';
              await widget.documentosViewModel.carregarDocumentos(email);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: docs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final doc = docs[index];
                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: tema.colorScheme.outlineVariant.withOpacity(0.5),
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.pushNamed(context, '/editor', arguments: doc);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  doc.titulo,
                                  style: tema.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 20),
                                tooltip: 'Editar',
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/editor',
                                    arguments: doc,
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 20,
                                  color: Colors.redAccent,
                                ),
                                tooltip: 'Excluir',
                                onPressed: () => _confirmarExclusao(doc),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            doc.conteudo.isEmpty
                                ? '(Documento sem conteúdo)'
                                : doc.conteudo,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: tema.textTheme.bodyMedium?.copyWith(
                              color: tema.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: tema.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatarData(doc.dataModificacao),
                                style: tema.textTheme.bodySmall?.copyWith(
                                  color: tema.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/editor');
        },
        icon: const Icon(Icons.add),
        label: const Text('Novo Documento'),
      ),
    );
  }
}
