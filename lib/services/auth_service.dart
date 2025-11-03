import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../model/user_model.dart';
import 'database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseService _dbService  = DatabaseService();

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String nome,
  }) async {
    try {

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

    String userId = userCredential.user!.uid;

    UserModel newUser = UserModel(
      id: userId,
      email: email,
      nome: nome,
  );

  await _firestore.collection('users').doc(userId).set(newUser.toMap());
  await _dbService.insertUser(newUser);

  debugPrint('Usuário cadastrado com sucesso: ${newUser.nome}');
  
  return newUser;

    } on FirebaseAuthException catch (e) {
      String errorMessage = _getErrorMessage(e.code);
      debugPrint('Erro ao cadastrar usuário: $errorMessage');
      throw Exception(errorMessage);
    } catch (e) {
      debugPrint('Erro inesperado: $e');
      throw Exception('Erro ao cadastrar usuário');
    }
  }

  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;
      DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();

      if(!doc.exists){
        throw Exception('Usuário não encontrado no banco de dados.');
      }

      UserModel user = UserModel.fromMap(doc.data() as Map<String, dynamic>);

      await _dbService.insertUser(user);
      
      debugPrint('Login realizado: ${user.nome}');
      return user;
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getErrorMessage(e.code);
      debugPrint('Erro ao realizar login: $errorMessage');
      throw Exception(errorMessage);
    } catch (e) {
      debugPrint('Erro inesperado no login: $e');
      throw Exception('Erro ao realizar login');
    }
  }

  Future<UserModel?> signInOffline(String userId) async {
    try {
      UserModel? user = await _dbService.getUser(userId);

      if(user == null){
        throw Exception('Nenhum usuário encontrado localmente.');
      }

      debugPrint('Login offline: ${user.nome}');
      return user;

    } catch (e) {
      debugPrint('Erro no login offline: $e');
      throw Exception('Erro no login offline');
    }
  }

  Future<void> signOut() async {
    try{

    await _auth.signOut();

    debugPrint('Logout realizado.');
    } catch(e){
      debugPrint('Erro no logout: $e');
      throw Exception('Erro ao realizar logout');
    }
  }

  Future<bool> isOnline() async {
    try {
      await _firestore.collection('users').limit(1).get();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> syncUserData() async {
    try {
      if(currentUser == null) return;
      
      String userId = currentUser!.uid;
      DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
      
      if(doc.exists){
        UserModel user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
        await _dbService.insertUser(user);
        debugPrint('Dados sincronizados.');
      }
    } catch (e) {
        debugPrint('Erro ao sincronizar: $e');
    }
  }

  String _getErrorMessage(String errorCode)
  {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'Este email já está em uso.';
      case 'invalid-email':
        return 'Email inválido.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'weak-password':
        return 'A senha é muito fraca (mínimo de 6 caracteres).';
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      default:
        return 'Erro desconhecido: $errorCode';
    }
  }
}
