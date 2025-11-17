import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_agendamento/model/servico_model.dart';

class ServicoService { 
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'servicos';

  Stream<List<ServicoModel>> getAllServicos() {
    try {
      return _firestore.collection(_collection)
        .orderBy('nome')
        .snapshots()
        .map((snapshot) {
          var lista = snapshot.docs.map((doc) {
            return ServicoModel.fromMap(doc.data());
          }).toList();

          lista.sort((a, b) => a.nome.compareTo(b.nome));
          return lista;
        });
    } catch (e) {
      throw Exception('Erro ao buscar serviços: $e');
    }
  }
  
  Stream<List<ServicoModel>> getServicosAsync() {
    try {
      return _firestore.collection(_collection)
        .where('ativo', isEqualTo: true)
        .orderBy('nome')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ServicoModel.fromMap(doc.data());
          }).toList();
        });
    } catch (e) {
      throw Exception('Erro ao buscar serviços: $e');
    }
  }

  Future<ServicoModel?> getServicoById (String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_collection).doc(id).get();
      
      if (!doc.exists) return null; 

      return ServicoModel.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Erro ao buscar serviço por ID: $e');
    }
  }

  Future<ServicoModel> createServico({
    required String nome, 
    required int duracaoMinutos,
    required double preco,

  }) async {
    try {

      final String id = _firestore.collection(_collection).doc().id;

      ServicoModel newServico = ServicoModel(
        id: id,
        nome: nome,
        duracaoMinutos: duracaoMinutos,
        preco: preco,
        ativo: true,
      );

      await _firestore.collection(_collection).doc(id).set(newServico.toMap());

      return newServico;
      
    } catch (e) {
      throw Exception('Erro ao criar serviço: $e');
    }
  }

  Future<bool> updateServico(ServicoModel servico) async {
    try {
      await _firestore.
        collection(_collection)
        .doc(servico.id)
        .update(servico.toMap());

        return true;
    } catch (e) {
      throw Exception('Erro ao atualizar serviço: $e');
    }
  } 

  Future<bool> softDeleteServico(String id) async {
    try {
      await _firestore
        .collection(_collection)
        .doc(id)  
        .update({'ativo' : false});

        return true;
    } catch (e) {
      throw Exception('Erro ao desativar serviço: $e');
    }
  }

  Future<bool> reactivateServico(String id) async {
    try {
      await _firestore
        .collection(_collection)
        .doc(id)
        .update({'ativo' : true});

        return true;
    } catch (e) {
      throw Exception('Erro ao reativar serviço: $e'); 
    }
  }
}