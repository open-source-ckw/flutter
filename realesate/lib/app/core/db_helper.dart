import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:path/path.dart';
import 'model_config.dart';

class DbHelper {
  Database? _database; // Singleton Database
  final _lock = new Lock();

  String dbName = 'config.db';
  int dbVersion = 1;
  String configTable = 'config';
  String key = 'key';
  String val = 'value';

  void dbSqfLite(dbName) {
    this.dbName = dbName;
  }

  Future<Database> get database async {
    if (_database == null) {
      // Prevent database lock warning in android device
      await _lock.synchronized(() async {
        // Check again once entering the synchronized block
        if (_database == null) {
          _database = await initializeDatabase();
        }
      });
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and IOS to store database.
    // NOTE : I changed path_provider to only path package
    String path =
        join(await getDatabasesPath(), dbName); //directory.path + dbName;

    // Open/create the database at a given path
    var configDatabase = await openDatabase(path,
        version: dbVersion, onCreate: _createDb, singleInstance: false);

    return configDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $configTable($key TEXT, $val TEXT)');
  }

  // Get all config from API and set it into global variable
  Future<List<Config>> _getLocalStorageData() async {
    List<Config> confList = <Config>[];

    // Get 'Map List' from database
    var configMapList = await getConfigMapList();

    // Check map config is not empty
    if (configMapList.isNotEmpty && configMapList.length > 0) {
      return await setConfigObj(configMapList);
    }
    return confList;
  }

  // Get all config from API and set it into global variable
  Future<Map<String, dynamic>> getLocalStorageData() async {
    Map<String, dynamic> confMap = {};

    // Get 'Map List' from database
    var configMapList = await getConfigMapList();

    // Check map config is not empty
    if (configMapList.isNotEmpty && configMapList.length > 0) {
      for (var i = 0; i < configMapList.length; i++) {
        confMap[configMapList[i][key]] = configMapList[i][val];
      }
    }
    return confMap;
  }

  // Fetch Operation: Get all config objects from database
  Future<List<Map<String, dynamic>>> getConfigMapList() async {
    Database db = await this.database;
    var result = await db.query(configTable);
    return result;
  }

  // Set config list from map
  Future<List<Config>> setConfigObj(
      List<Map<String, dynamic>> configMapList) async {
    List<Config> confList = <Config>[];
    int count =
        configMapList.length; // Count the number of map entries in db table
    // For loop to create a 'Config List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      confList.add(Config.fromMapObject(configMapList[i]));
    }
    return confList;
  }

  // Insert Operation: Insert a Config object to database
  // ignore: missing_return
  Future<int> insertConfig(Config cfg) async {
    var dbClient = await this.database;

    return await dbClient.transaction((txn) async {
      return await txn.insert(configTable, cfg.toMap());
      //return await txn.rawQuery('INSERT INTO $configTable ($key, $val) VALUES('"${cfg.key}"' , '"${cfg.value}"') ON CONFLICT ($key) DO UPDATE SET $val = ${cfg.key}');
    });
  }

  deleteParam(String passkey) async {
    final db = await database;
    await db.rawQuery("DELETE FROM $configTable WHERE $key = '$passkey'");
  }

  updateParam(Config cfg) async {
    final db = await database;
    await db.update("$configTable", cfg.toMap(),
        where: "$key = ?", whereArgs: [cfg.key]);
  }

  Future close() async => _database?.close();
}
