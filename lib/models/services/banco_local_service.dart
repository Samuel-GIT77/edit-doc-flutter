import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../usuario.dart';
import '../documento.dart';

class BancoLocalService {
  static const String _chaveUsuarios = 'banco_usuarios';
  static const String _chaveDocumentos = 'banco_documentos';

  // Lista em memória inicial (com usuário de teste para permitir login imediato)
  final List<Usuario> _usuariosMemoria = [
    Usuario(
      id: '1',
      nome: 'Usuário Teste',
      email: 'admin@exemplo.com',
      senha: '123456',
    ),
  ];

  final List<Documento> _documentosMemoria = [
    Documento(
      id: 'doc-1',
      titulo: 'Documento de Apresentação',
      conteudo:
          'Bem-vindo ao Editor de Documentos em Flutter com arquitetura MVVM!',
      dataModificacao: DateTime.now().subtract(const Duration(hours: 2)),
      autorEmail: 'admin@exemplo.com',
    ),
    Documento(
      id: 'doc-2',
      titulo: 'Plano de Estudos Flutter',
      conteudo:
          '1. Model-View-ViewModel\n2. ChangeNotifier e ListenableBuilder\n3. Rotas Nomeadas\n4. Persistência Local',
      dataModificacao: DateTime.now().subtract(const Duration(minutes: 30)),
      autorEmail: 'admin@exemplo.com',
    ),
  ];

  // ==================== USUÁRIOS ====================

  Future<List<Usuario>> obterUsuarios() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dadosStr = prefs.getString(_chaveUsuarios);
      if (dadosStr != null && dadosStr.isNotEmpty) {
        final List<dynamic> listaJson = jsonDecode(dadosStr);
        return listaJson
            .map((e) => Usuario.fromMap(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return List.from(_usuariosMemoria);
  }

  Future<bool> cadastrarUsuario(Usuario usuario) async {
    try {
      final usuarios = await obterUsuarios();
      final jaExiste = usuarios.any(
        (u) => u.email.toLowerCase() == usuario.email.toLowerCase(),
      );
      if (jaExiste) {
        return false;
      }

      usuarios.add(usuario);
      _usuariosMemoria.add(usuario);

      final prefs = await SharedPreferences.getInstance();
      final jsonLista = jsonEncode(usuarios.map((u) => u.toMap()).toList());
      await prefs.setString(_chaveUsuarios, jsonLista);
      return true;
    } catch (_) {
      _usuariosMemoria.add(usuario);
      return true;
    }
  }

  Future<Usuario?> autenticar(String email, String senha) async {
    final usuarios = await obterUsuarios();
    try {
      return usuarios.firstWhere(
        (u) =>
            u.email.toLowerCase() == email.trim().toLowerCase() &&
            u.senha == senha,
      );
    } catch (_) {
      return null;
    }
  }

  Future<Usuario?> buscarPorEmail(String email) async {
    final usuarios = await obterUsuarios();
    try {
      return usuarios.firstWhere(
        (u) => u.email.toLowerCase() == email.trim().toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  // ==================== DOCUMENTOS (CRUD) ====================

  Future<List<Documento>> obterDocumentos({String? autorEmail}) async {
    List<Documento> docs = [];
    try {
      final prefs = await SharedPreferences.getInstance();
      final dadosStr = prefs.getString(_chaveDocumentos);
      if (dadosStr != null && dadosStr.isNotEmpty) {
        final List<dynamic> listaJson = jsonDecode(dadosStr);
        docs = listaJson
            .map((e) => Documento.fromMap(e as Map<String, dynamic>))
            .toList();
      } else {
        docs = List.from(_documentosMemoria);
      }
    } catch (_) {
      docs = List.from(_documentosMemoria);
    }

    if (autorEmail != null && autorEmail.isNotEmpty) {
      return docs
          .where((d) => d.autorEmail.toLowerCase() == autorEmail.toLowerCase())
          .toList()
        ..sort((a, b) => b.dataModificacao.compareTo(a.dataModificacao));
    }

    return docs..sort((a, b) => b.dataModificacao.compareTo(a.dataModificacao));
  }

  Future<bool> salvarDocumento(Documento doc) async {
    try {
      final docs = await obterDocumentos();
      final index = docs.indexWhere((d) => d.id == doc.id);

      if (index >= 0) {
        docs[index] = doc;
      } else {
        docs.insert(0, doc);
      }

      _documentosMemoria.clear();
      _documentosMemoria.addAll(docs);

      final prefs = await SharedPreferences.getInstance();
      final jsonLista = jsonEncode(docs.map((d) => d.toMap()).toList());
      await prefs.setString(_chaveDocumentos, jsonLista);
      return true;
    } catch (_) {
      final index = _documentosMemoria.indexWhere((d) => d.id == doc.id);
      if (index >= 0) {
        _documentosMemoria[index] = doc;
      } else {
        _documentosMemoria.insert(0, doc);
      }
      return true;
    }
  }

  Future<bool> excluirDocumento(String id) async {
    try {
      final docs = await obterDocumentos();
      docs.removeWhere((d) => d.id == id);
      _documentosMemoria.removeWhere((d) => d.id == id);

      final prefs = await SharedPreferences.getInstance();
      final jsonLista = jsonEncode(docs.map((d) => d.toMap()).toList());
      await prefs.setString(_chaveDocumentos, jsonLista);
      return true;
    } catch (_) {
      _documentosMemoria.removeWhere((d) => d.id == id);
      return true;
    }
  }
}
