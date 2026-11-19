class Documento {
  final String id;
  final String titulo;
  final String conteudo;
  final DateTime dataModificacao;
  final String autorEmail;

  Documento({
    required this.id,
    required this.titulo,
    required this.conteudo,
    required this.dataModificacao,
    required this.autorEmail,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'conteudo': conteudo,
      'dataModificacao': dataModificacao.toIso8601String(),
      'autorEmail': autorEmail,
    };
  }

  factory Documento.fromMap(Map<String, dynamic> map) {
    return Documento(
      id: map['id'] as String? ?? '',
      titulo: map['titulo'] as String? ?? '',
      conteudo: map['conteudo'] as String? ?? '',
      dataModificacao: map['dataModificacao'] != null
          ? DateTime.tryParse(map['dataModificacao'] as String) ??
                DateTime.now()
          : DateTime.now(),
      autorEmail: map['autorEmail'] as String? ?? '',
    );
  }

  Documento copyWith({
    String? id,
    String? titulo,
    String? conteudo,
    DateTime? dataModificacao,
    String? autorEmail,
  }) {
    return Documento(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      conteudo: conteudo ?? this.conteudo,
      dataModificacao: dataModificacao ?? this.dataModificacao,
      autorEmail: autorEmail ?? this.autorEmail,
    );
  }
}
