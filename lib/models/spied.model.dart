import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SpiedModel {
  Database? _database;

  Future<void> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'spy.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE spied(id INTEGER PRIMARY KEY, name TEXT, code TEXT)',
        );
      },
    );
  }

  Future<String?> getSpied() async {
    final result = await _database?.query('spied');
    if (result != null && result.isNotEmpty) {
      return result.first['name'] as String?;
    }
    return null;
  }

  Future<void> saveSpied(String name, String code) async {
    await _database?.insert(
      'spied',
      {'name': name, 'code': code},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteSpied() async {
    await _database?.delete('spied');
  }
}