class ServicoModel {
  final String id;
  final String nome;
  final int duracaoMinutos;
  final double preco;
  final bool ativo;

  ServicoModel({
    required this.id,
    required this.nome,
    required this.preco,
    required this.duracaoMinutos,
    this.ativo = true,
  });

  factory ServicoModel.fromMap(Map<String, dynamic> map) {
    return ServicoModel(
      id: map['id'] as String,
      nome: map['nome'] as String,
      duracaoMinutos: map['duracaoMinutos'] as int,
      preco: map['preco'] as double,
      ativo: map['ativo'] == true || map['ativo'] == 1, 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'duracaoMinutos': duracaoMinutos,
      'preco': preco,
      'ativo': ativo == true ? true : false,
    };
  }

  String get duracaoFormatada {
    int horas = duracaoMinutos ~/ 60;
    int minutos = duracaoMinutos % 60;

    if (horas > 0 && minutos > 0) {
      return '${horas}h ${minutos}m';
    } else if (horas > 0) {
      return '${horas}h';
    } else {
      return '${minutos}m';
    }
  }

  @override
  String toString() {
    return 'ServicoModel(id: $id, nome: $nome, duracaoMinutos: $duracaoMinutos, preco: $preco, ativo: $ativo)';
  }
}