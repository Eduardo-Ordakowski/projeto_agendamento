import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../model/user_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal() {
    if (!kIsWeb) {
      try {
        if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
          sqfliteFfiInit();
          databaseFactory = databaseFactoryFfi;
        }
      } catch (e) {
        debugPrint('Erro ao inicializar SQLite: $e');
      }
    }
  }

  Future<Database?> get database async {
    if (kIsWeb) {
      debugPrint('SQLite não disponível no Web - operação ignorada');
      return null;
    }

    if (_database != null) return _database!;

    try {
      _database = await _initDatabase();
      return _database;
    } catch (e) {
      debugPrint('Erro ao inicializar banco: $e');
      return null;
    }
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'agendamento.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      id TEXT PRIMARY KEY,
      email TEXT NOT NULL,
      nome TEXT NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE atendentes (
      id TEXT PRIMARY KEY,
      nome TEXT NOT NULL,
      especialidade TEXT,
      ativo INTEGER NOT NULL DEFAULT 1
    )
  ''');

    await db.execute('''
    CREATE TABLE servicos (
      id TEXT PRIMARY KEY,
      nome TEXT NOT NULL,
      duracaoMinutos INTEGER NOT NULL,
      preco REAL NOT NULL,
      ativo INTEGER NOT NULL DEFAULT 1
    )
  ''');

    await db.execute('''
    CREATE TABLE agendamentos (
      id TEXT PRIMARY KEY,
      clienteId TEXT NOT NULL,
      clienteNome TEXT NOT NULL,
      clienteTelefone TEXT,
      atendenteId TEXT NOT NULL,
      atendenteNome TEXT NOT NULL,
      servicoId TEXT NOT NULL,
      servicoNome TEXT NOT NULL,
      dataHora TEXT NOT NULL,
      status TEXT NOT NULL DEFAULT 'pendente',
      observacoes TEXT,
      criadoEm TEXT NOT NULL
    )
  ''');
  }

  Future<void> insertUser(UserModel user) async {
    if (kIsWeb) {
      debugPrint('SQLite não disponível no Web - operação ignorada');
      return;
    }

    try {
      final db = await database;
      if (db == null) return;

      await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint('Usuário salvo no SQLite');
    } catch (e) {
      debugPrint('Erro ao salvar no SQLite (ignorado): $e');
    }
  }

  Future<UserModel?> getUser(String id) async {
    if (kIsWeb) {
      debugPrint('SQLite não disponível no Web');
      return null;
    }

    try {
      final db = await database;
      if (db == null) return null;

      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) return null;
      return UserModel.fromMap(maps.first);
    } catch (e) {
      debugPrint('Erro ao buscar no SQLite: $e');
      return null;
    }
  }

  Future<void> deleteUser(String id) async {
    if (kIsWeb) return;

    try {
      final db = await database;
      if (db == null) return;

      await db.delete('users', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint('Erro ao deletar do SQLite: $e');
    }
  }

  Future<void> clearAllData() async {
    if (kIsWeb) return;

    try {
      final db = await database;
      if (db == null) return;

      await db.delete('users');
      await db.delete('atendentes');
      await db.delete('servicos');
      await db.delete('agendamentos');
    } catch (e) {
      debugPrint('Erro ao limpar dados: $e');
    }
  }
}
