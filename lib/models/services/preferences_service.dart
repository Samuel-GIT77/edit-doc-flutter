import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _chaveTemaEscuro = 'preferencia_tema_escuro';
  static const String _chaveEmailUsuarioLogado = 'preferencia_email_logado';

  Future<bool> obterTemaEscuro() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_chaveTemaEscuro) ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> salvarTemaEscuro(bool isDark) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_chaveTemaEscuro, isDark);
    } catch (_) {}
  }

  Future<String?> obterEmailUsuarioLogado() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_chaveEmailUsuarioLogado);
    } catch (_) {
      return null;
    }
  }

  Future<void> salvarEmailUsuarioLogado(String? email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (email == null) {
        await prefs.remove(_chaveEmailUsuarioLogado);
      } else {
        await prefs.setString(_chaveEmailUsuarioLogado, email);
      }
    } catch (_) {}
  }

  Future<void> limparSessao() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_chaveEmailUsuarioLogado);
    } catch (_) {}
  }
}
