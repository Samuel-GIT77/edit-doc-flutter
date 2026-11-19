class Usuario {
  final String id;
  final String nome;
  final String email;
  final String senha;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'email': email, 'senha': senha};
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] as String? ?? '',
      nome: map['nome'] as String? ?? '',
      email: map['email'] as String? ?? '',
      senha: map['senha'] as String? ?? '',
    );
  }

  Usuario copyWith({String? id, String? nome, String? email, String? senha}) {
    return Usuario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      senha: senha ?? this.senha,
    );
  }
}
