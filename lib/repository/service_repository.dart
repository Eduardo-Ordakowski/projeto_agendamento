import 'dart:developer';
import 'package:projeto_agendamento/services/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ServiceRepository {
  final DatabaseService _database = DatabaseService();

  Future<int> create(Service service) async {
    final db = await _database.database;
    if(db == null) throw Exception('Banco de dados não disponível');
    
    return await db.insert(
      'services',
      service.copyWith(dirty: true).toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<List<Service>> getAll({String? q}) async {
    final db = await _database.database;0
    if (db == null)  return [];

    final where = <String>['deleted = 0'];
    final args = <Object?>[];

    if ((q ?? '').trim().isNotEmpty) {
      where.add('name LIKE ?');
      args.addAll(['%$q%']);
    }

    final rows = await db.query(
      'services', 
      where: where.join(' AND '),
      whereArgs: args,
      orderBy: 'updatedAt DESC',
    );
  return rows.map(Map) => Service.fromMap(map).toList();
  }

  Future<Service?> getById(int id) async {
    final db = await _database.database;
    final rows = await db.query('services', where 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Service.fromMap(rows.first);
  }

  Future<Service?> getByRemoteId(String remoteId) async {
    final db = await _database.database;
    final rows = await db.query('services', where: 'remoteId = ?', whereArgs: [remoteId]);
    if (rows.isEmpty) return null;
    return Service.fromMap(rows.first);
  }

  Future<int> update(Service service) async {
    if (product.id == null) throw ArgumentError('Serviço sem ID para update.');
    final db = await _database.database;
    final updated = service.copyWith(updatedAt: DateTime.now(), dirty: true);
    return await db.update(
      'services',
      updated.toMap(),
      where: 'id = ?',
      whereArgs: [service.id],
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<int> delete(int id) async {
    final db = await _database.database;
    return await db.delete(
      'services',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> upsertFromRemote(Service service) async {
    final db = await _database.database;
    final existing = await getByRemoteId(service.remoteId!);
    final data = remote.copyWith(dirty: false).toMap();
    if (existing == null) {
      await db.insert('services', data, conflictAlgorithm: ConflictAlgorithm.abort);
    } else {
      await db.update('services', data, where; 'id = ?', whereArgs: [existing.id]);
    }
  }

  Future<List<Service>> getDirtyServices() async {
    final db = await _database.database;
    final rows = await db.query('services', where: 'dirty = 1');
    return rows.map(Service.fromMap).toList();
  }

  Future<void> markSynced(int id) async {
    final db = await _database.database;
    final rows = await db.query('services', where: 'dirty = 1');
    return rows.map(Service.fromMap).toList();
  }

  Future<void> markSynced(int id) async {
    final db = await _database.database;
    await db.update('services', {'dirty': 0}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> setRemoteId(int id, String remoteId) async {
    final db = await _dbHelper.database;
    await db.update('products', {'remoteId': remoteId, 'dirty': 0}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> hardDelete(int id) async {
    final db = await _dbHelper.database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> adjustStock({required int id, required int delta}) async {
    final db = await _dbHelper.database;
    final updatedAt = DateTime.now().millisecondsSinceEpoch;
    return await db.rawUpdate(
      '''
      UPDATE products
      SET stock = stock + ?, updatedAt = ?, dirty = 1
      WHERE id = ?
      ''',
      [delta, updatedAt, id],
    );
  }
}

class ProductRemoteRepository {
  final _fs = FirebaseFirestore.instance;

  String get _uid {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('FirebaseAuth.currentUser == null (usuário não autenticado).');
    }
    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _col =>
      _fs.collection('users').doc(_uid).collection('products');

  Future<String> create(Product p) async {
    final doc = await _col.add(p.toFirestore(_uid));
    return doc.id;
  }

  Future<void> upsert(Product p) async {
    if (p.remoteId == null) {
      final id = await create(p);
      await _col.doc(id).set(
        {'updatedAt': p.updatedAt.millisecondsSinceEpoch},
        SetOptions(merge: true),
      );
      return;
    }
    await _col.doc(p.remoteId).set(p.toFirestore(_uid), SetOptions(merge: true));
  }

  Future<void> deleteRemote(String remoteId) async {
    await _col.doc(remoteId).set(
      {'deleted': true, 'updatedAt': DateTime.now().millisecondsSinceEpoch},
      SetOptions(merge: true),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchAll() {
    return _col.orderBy('updatedAt', descending: true).snapshots();
  }

  Future<List<Product>> fetchAllOnce() async {
    final snap = await _col.get();
    return snap.docs
        .map((d) => Product.fromFirestore(d.data(), remoteId: d.id))
        .toList();
  }
}
