import 'package:flutter/foundation.dart';

import '../models/documento.dart';
import '../models/services/banco_local_service.dart';

class DocumentosViewModel extends ChangeNotifier {
  final BancoLocalService _bancoService;

  List<Documento> _documentos = [];
  bool _isLoading = false;
  String? _mensagemErro;
  String? _autorEmailAtual;

  DocumentosViewModel({required BancoLocalService bancoService})
      : _bancoService = bancoService;

  List<Documento> get documentos => List.unmodifiable(_documentos);
  bool get isLoading => _isLoading;
  String? get mensagemErro => _mensagemErro;

  Future<void> carregarDocumentos(String autorEmail) async {
    _autorEmailAtual = autorEmail;
    _isLoading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      _documentos = await _bancoService.obterDocumentos(autorEmail: autorEmail);
    } catch (e) {
      _mensagemErro = 'Falha ao carregar documentos.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> salvarDocumento({
    String? id,
    required String titulo,
    required String conteudo,
    required String autorEmail,
  }) async {
    _isLoading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final doc = Documento(
        id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        titulo: titulo.trim(),
        conteudo: conteudo.trim(),
        dataModificacao: DateTime.now(),
        autorEmail: autorEmail,
      );

      final sucesso = await _bancoService.salvarDocumento(doc);
      if (sucesso) {
        if (_autorEmailAtual != null) {
          _documentos = await _bancoService.obterDocumentos(
            autorEmail: _autorEmailAtual,
          );
        }
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _mensagemErro = 'Não foi possível salvar o documento.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _mensagemErro = 'Erro ao salvar documento.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> excluirDocumento(String id) async {
    _isLoading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final sucesso = await _bancoService.excluirDocumento(id);
      if (sucesso) {
        _documentos.removeWhere((doc) => doc.id == id);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _mensagemErro = 'Não foi possível excluir o documento.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _mensagemErro = 'Erro ao excluir o documento.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void limparErro() {
    _mensagemErro = null;
    notifyListeners();
  }
}
