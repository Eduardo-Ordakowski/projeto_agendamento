import 'package:cloud_firestore/cloud_firestore.dart';

class AgendamentoModel {
  final String id;
  final String clienteId;
  final String clienteNome;
  final String? clienteTelefone;

  final String atendenteId;
  final String? atendenteNome;
  
  final String servicoId;
  final String? servicoNome;
  
  final DateTime dataHoraInicio;
  final DateTime dataHoraFim;

  final String status;


  final String? observacoes;
  final String? motivoCancelamento;

  final DateTime dataCriacao;
  final DateTime? dataAtualizacao;
  final DateTime? dataCancelamento;

  AgendamentoModel({
    required this.id,
    required this.clienteId,
    required this.clienteNome,
    this.clienteTelefone,
    required this.atendenteId,
    this.atendenteNome,
    required this.servicoId,
    this.servicoNome,
    required this.dataHoraInicio,
    required this.dataHoraFim,
    this.status = 'pendente',
    this.observacoes,
    this.motivoCancelamento,
    required this.dataCriacao,
    this.dataAtualizacao,
    this.dataCancelamento,
  });

  factory AgendamentoModel.fromMap(Map<String, dynamic> map) {
    return AgendamentoModel(
      id: map['id'] as String,
      clienteId: map['clienteId'] as String,
      clienteNome: map['clienteNome'] as String,
      clienteTelefone: map['clienteTelefone'] as String?,
      atendenteId: map['atendenteId'] as String,
      atendenteNome: map['atendenteNome'] as String?,
      servicoId: map['servicoId'] as String,
      servicoNome: map['servicoNome'] as String?,

      dataHoraInicio: _parseDateTime(map['dataHoraInicio']),
      dataHoraFim: _parseDateTime(map['dataHoraFim']),

      status: map['status'] as String,
      observacoes: map['observacoes'] as String?,
      motivoCancelamento: map['motivoCancelamento'] as String?,
      
      dataCriacao: _parseDateTime(map['dataCriacao']),
        dataAtualizacao: map['dataAtualizacao'] != null 
          ? _parseDateTime(map['dataAtualizacao']) 
          : null,
      dataCancelamento: map['dataCancelamento'] != null 
          ? _parseDateTime(map['dataCancelamento']) 
          : null,
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) {
      return DateTime.now();
    }

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is String) {
      return DateTime.parse(value);
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.now();
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
      'dataHoraInicio': Timestamp.fromDate(dataHoraInicio),
      'dataHoraFim': Timestamp.fromDate(dataHoraFim),
      'status': status,
      'observacoes': observacoes,
      'motivoCancelamento': motivoCancelamento,
      'dataCriacao': Timestamp.fromDate(dataCriacao),
      'dataAtualizacao': dataAtualizacao != null 
          ? Timestamp.fromDate(dataAtualizacao!) 
          : null,
      'dataCancelamento': dataCancelamento != null 
          ? Timestamp.fromDate(dataCancelamento!) 
          : null,
    };
  }
  AgendamentoModel copyWith({
    String? id,
    String? clienteId,
    String? clienteNome,
    String? clienteTelefone,
    String? atendenteId,
    String? atendenteNome,
    String? servicoId,
    String? servicoNome,
    DateTime? dataHoraInicio,
    DateTime? dataHoraFim,
    String? status,
    String? observacoes,
    String? motivoCancelamento,
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
    DateTime? dataCancelamento,
  }) {
    return AgendamentoModel(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      clienteNome: clienteNome ?? this.clienteNome,
      clienteTelefone: clienteTelefone ?? this.clienteTelefone,
      atendenteId: atendenteId ?? this.atendenteId,
      atendenteNome: atendenteNome ?? this.atendenteNome,
      servicoId: servicoId ?? this.servicoId,
      servicoNome: servicoNome ?? this.servicoNome,
      dataHoraInicio: dataHoraInicio ?? this.dataHoraInicio,
      dataHoraFim: dataHoraFim ?? this.dataHoraFim,
      status: status ?? this.status,
      observacoes: observacoes ?? this.observacoes,
      motivoCancelamento: motivoCancelamento ?? this.motivoCancelamento,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
      dataCancelamento: dataCancelamento ?? this.dataCancelamento,
    );
  }

  @override
  String toString() {
    return 'AgendamentoModel(id: $id, cliente: $clienteNome, '
           'dataHora: $dataHoraInicio → $dataHoraFim, status: $status)';
  }
}