class UserModel {
  final String id;
  final String email;
  final String nome;

  UserModel({
    required this.id,
    required this.email,
    required this.nome,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      nome: map['nome'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return{
      'id': id,
      'email': email,
      'nome': nome,
    };
  }

  @override
  String toString(){
    return 'UserModel(id: $id, email: $email, nome: $nome)';
  }
}