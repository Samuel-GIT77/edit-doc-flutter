import 'package:flutter/foundation.dart';

import '../models/usuario.dart';
import '../models/services/banco_local_service.dart';
import '../models/services/preferences_service.dart';

class AuthViewModel extends ChangeNotifier {
  final BancoLocalService _bancoService;
  final PreferencesService _prefsService;

  Usuario? _usuarioAtual;
  bool _isDarkTheme = false;
  bool _isLoading = false;
  String? _mensagemErro;

  AuthViewModel({
    required BancoLocalService bancoService,
    required PreferencesService prefsService,
  }) : _bancoService = bancoService,
       _prefsService = prefsService;

  Usuario? get usuarioAtual => _usuarioAtual;
  bool get isAutenticado => _usuarioAtual != null;
  bool get isDarkTheme => _isDarkTheme;
  bool get isLoading => _isLoading;
  String? get mensagemErro => _mensagemErro;

  Future<void> inicializar() async {
    _isLoading = true;
    notifyListeners();

    try {
      _isDarkTheme = await _prefsService.obterTemaEscuro();
      final emailSalvo = await _prefsService.obterEmailUsuarioLogado();
      if (emailSalvo != null && emailSalvo.isNotEmpty) {
        final usuario = await _bancoService.buscarPorEmail(emailSalvo);
        if (usuario != null) {
          _usuarioAtual = usuario;
        }
      }
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String senha) async {
    _isLoading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final usuario = await _bancoService.autenticar(email, senha);
      if (usuario != null) {
        _usuarioAtual = usuario;
        await _prefsService.salvarEmailUsuarioLogado(usuario.email);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _mensagemErro = 'E-mail ou senha inválidos.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _mensagemErro = 'Erro ao realizar login. Tente novamente.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> cadastrar(String nome, String email, String senha) async {
    _isLoading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final novoUsuario = Usuario(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nome: nome.trim(),
        email: email.trim(),
        senha: senha,
      );

      final sucesso = await _bancoService.cadastrarUsuario(novoUsuario);
      if (sucesso) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _mensagemErro = 'Já existe um usuário cadastrado com este e-mail.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _mensagemErro = 'Erro ao cadastrar usuário. Tente novamente.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _usuarioAtual = null;
    await _prefsService.limparSessao();
    notifyListeners();
  }

  Future<void> alternarTema() async {
    _isDarkTheme = !_isDarkTheme;
    await _prefsService.salvarTemaEscuro(_isDarkTheme);
    notifyListeners();
  }

  void limparErro() {
    _mensagemErro = null;
    notifyListeners();
  }
}
