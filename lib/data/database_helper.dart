import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final dbname = 'notes.db';
  static final dbversion = 1;
  static final tableName1 = 'Notes';
  static final tableName2 = 'Trash';

  static final columnID = '_id';
  static final columnTitle = 'title';
  static final columnDesc = 'desc';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initiateDatabase();
    return _database;
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbname);
    return await openDatabase(path, version: dbversion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableName1 (
    $columnID INTEGER PRIMARY KEY,
    $columnTitle TEXT NOT NULL,
    $columnDesc VARCHAR(100) NOT NULL ) 
    ''');
    await db.execute('''
    CREATE TABLE $tableName2 (
    $columnID INTEGER PRIMARY KEY,
    $columnTitle TEXT NOT NULL,
    $columnDesc VARCHAR(100) NOT NULL ) 
    ''');
  }

  Future<int> insert1(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableName1, row);
  }

  Future<List<Map<String, dynamic>>> queryAll1() async {
    Database db = await instance.database;
    return await db.query(tableName1);
  }

  Future<int> delete1() async {
    Database db = await instance.database;
    return await db.delete(tableName1);
  }

  Future<int> insert2(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableName2, row);
  }

  Future<List<Map<String, dynamic>>> queryAll2() async {
    Database db = await instance.database;
    return await db.query(tableName2);
  }

  Future<int> delete2() async {
    Database db = await instance.database;
    return await db.delete(tableName2);
  }
}
