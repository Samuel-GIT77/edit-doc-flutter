class Validadores {
  static String? validarNome(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'O nome é obrigatório.';
    }
    if (valor.trim().length < 3) {
      return 'O nome deve ter pelo menos 3 caracteres.';
    }
    return null;
  }

  static String? validarEmail(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'O e-mail é obrigatório.';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(valor.trim())) {
      return 'Informe um e-mail válido (ex: usuario@email.com).';
    }
    return null;
  }

  static String? validarSenha(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'A senha é obrigatória.';
    }
    if (valor.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres.';
    }
    return null;
  }

  static String? validarConfirmacaoSenha(String? valor, String? senhaOriginal) {
    if (valor == null || valor.isEmpty) {
      return 'A confirmação de senha é obrigatória.';
    }
    if (valor != senhaOriginal) {
      return 'As senhas não coincidem.';
    }
    return null;
  }

  static String? validarTitulo(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'O título do documento é obrigatório.';
    }
    return null;
  }
}
