class AtendenteModel {
  final String id;
  final String nome;
  final String? especialidade;
  final bool ativo;

  AtendenteModel({
    required this.id,
    required this.nome,
    this.especialidade,
    this.ativo = true,
  });

  factory AtendenteModel.fromMap(Map<String, dynamic> map) {
    return AtendenteModel(
      id: map['id'] as String,
      nome: map['nome'] as String,
      especialidade: map['especialidade'] as String?,
      ativo: map['ativo'] == true || map['ativo'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return{
      'id': id,
      'nome': nome,
      'especialidade': especialidade,
      'ativo': ativo == true ? true : false,
    };
  }

  @override
  String toString(){
    return 'AtendenteModel(id: $id, nome: $nome, especialidade: $especialidade)';
  }
}