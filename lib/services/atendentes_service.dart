import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_agendamento/model/atendente_model.dart';

class AtendenteService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'atendentes';

  Future<AtendenteModel> createAtendente({
    required String nome,
    String? especialidade,
  }) async {
    try {
    
      String id = _firestore.collection(_collection).doc().id;

      AtendenteModel newAtendente = AtendenteModel(
        id: id,
        nome: nome,
        especialidade: especialidade,
        ativo: true,
      );

      await _firestore
        .collection(_collection)
        .doc(id)
        .set(newAtendente.toMap());
    
      return newAtendente;
    } catch (e) {
    
      throw Exception('Erro ao criar atendente: $e');
    }
  }

  Stream<List<AtendenteModel>> getAllAtendentes() {
    try {
      return _firestore
        .collection(_collection)
        .orderBy('nome')
        .snapshots()
        .map((snapshot){
          return snapshot.docs.map((doc) {
            return AtendenteModel.fromMap(doc.data());
          }).toList();
        });
    } catch (e) {
      throw Exception('Erro ao buscar atendentes: $e');
    }
  }
  
  Stream<List<AtendenteModel>> getAtendentesAtivos() {
    try {
      return _firestore
        .collection(_collection)
        .where('ativo', isEqualTo: true)
        .orderBy('nome')
        .snapshots()
        .map((snapshot){
          return snapshot.docs.map((doc) {
            return AtendenteModel.fromMap(doc.data());
          }) .toList();
        });
    } catch (e) {
      throw Exception('Erro ao buscar atendentes: $e');
    }
  }

  Future<AtendenteModel?> getAtendenteById (String id) async {
    try {
      DocumentSnapshot doc = await _firestore
        .collection(_collection)
        .doc(id)
        .get();

        if (!doc.exists) return null;

        return AtendenteModel.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Erro ao buscar atendente por ID: $e');
    }
  }

  Future<bool> updateAtendente(AtendenteModel atendente) async {
    try {
      await _firestore
        .collection(_collection)
        .doc(atendente.id)
        .update(atendente.toMap());
      
      return true;
    } catch (e) {
      throw Exception('Erro ao atualizar atendente: $e');
    }
  }

  Future<bool> softDeleteAtendente(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).update({'ativo': false});
      return true;
    } catch (e) {
      throw Exception('Erro ao desativar atendente: $e');
    }
  }

  Future<bool> reactivateAtendente(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).update({'ativo': true});
      return true;
    } catch (e) {
      throw Exception('Erro ao reativar atendente: $e');
    }
  }
}


