class AgendamentoModel {
  final String id;
  final String clienteId;
  final String clienteNome;
  final String? clienteTelefone;
  final String atendenteId;
  final String atendenteNome;
  final String servicoId;
  final String servicoNome;
  final DateTime dataHora;
  final String status;
  final String? observacoes;
  final DateTime criadoEm;

  AgendamentoModel({
    required this.id,
    required this.clienteId,
    required this.clienteNome,
    this.clienteTelefone,
    required this.atendenteId,
    required this.atendenteNome,
    required this.servicoId,
    required this.servicoNome,
    required this.dataHora,
    this.status = 'pendente',
    this.observacoes,
    required this.criadoEm,
  });

  factory AgendamentoModel.fromMap(Map<String, dynamic> map) {
    return AgendamentoModel(
      id: map['id'] as String,
      clienteId: map['clienteId'] as String,
      clienteNome: map['clienteNome'] as String,
      clienteTelefone: map['clienteTelefone'] as String?,
      atendenteId: map['atendenteId'] as String,
      atendenteNome: map['atendenteNome'] as String,
      servicoId: map['servicoId'] as String,
      servicoNome: map['servicoNome'] as String,
      dataHora: DateTime.parse(map['dataHora'] as String),
      status: map['status'] as String,
      observacoes: map['observacoes'] as String?,
      criadoEm: DateTime.parse(map['criadoEm'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clienteId': clienteId,
      'clienteNome': clienteNome,
      'clienteTelefone': clienteTelefone,
      'atendenteId': atendenteId,
      'atendenteNome': atendenteNome,
      'servicoId': servicoId,
      'servicoNome': servicoNome,
      'dataHora': dataHora.toIso8601String(),
      'status': status,
      'observacoes': observacoes,
      'criadoEm': criadoEm.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'AgendamentoModel(id: $id, clienteId: $clienteId, clienteNome: $clienteNome, clienteTelefone: $clienteTelefone, atendenteId: $atendenteId, atendenteNome: $atendenteNome, servicoId: $servicoId, servicoNome: $servicoNome, dataHora: $dataHora, status: $status, observacoes: $observacoes)';
  }
}