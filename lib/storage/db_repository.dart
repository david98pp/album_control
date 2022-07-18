import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class DBRepository {
  DatabaseClient? _db;
  late StoreRef _store = StoreRef.main();

  /// Singleton pattern
  static final DBRepository _instance = DBRepository._internal();
  DBRepository._internal() {
    onInit();
  }
  factory DBRepository() => _instance;

  /// Default constructor
  void onInit() {
    initDB();
    _store = StoreRef.main();
  }

  /// DB Instance
  Future<void> initDB() async {
    final docDir = await getApplicationDocumentsDirectory();
    await docDir.create(recursive: true);
    _db ??= await databaseFactoryIo.openDatabase(join(docDir.path, 'ejem0.db'));
  }

  dynamic getDB() => _db;

  /// Add docs
  Future<void> set(String key, Map? value) async {
    value ??= {};
    await _store.record(key).put(_db!, value);
  }

  Future<void> setStr(String key, String value) async {
    await _store.record(key).put(_db!, value);
  }

  Future<void> setInt(String key, int value) async {
    await _store.record(key).put(_db!, value);
  }

  /// Retrieve docs
  Future<Map> get(String key) async {
    try {
      if (_db == null) {
        await initDB();
      }
      return await _store.record(key).get(_db!) as Map;
    } catch (e) {
      //print("Error al leer db. "+e.toString());
    }
    return {};
  }

  Future<String> getStr(String key) async {
    return await _store.record(key).get(_db!) as String;
  }

  Future<int> getInt(String key) async {
    return await _store.record(key).get(_db!) as int;
  }

  /// Remove docs
  Future<String> del(String key) async {
    await _store.record(key).delete(_db!);
    return "";
  }
}
