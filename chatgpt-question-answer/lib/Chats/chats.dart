import 'package:chat_gtp/models/list_chat_model.dart';
import 'package:chat_gtp/models/save_chat_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyDb {
  static Database? db;

  static final MyDb instance = MyDb._init();

  // static Database? _database;

  MyDb._init();

  Future<Database> get database async {
    if (db != null) return db!;

    db = await _initDB('ChatApp.db');
    return db!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';
    await db.execute('''
                  CREATE TABLE IF NOT EXISTS $tableTreads ( 
                       ${AllChatFields.id} $idType,
                       ${AllChatFields.title} $textType,
                       ${AllChatFields.u_id} $textType,
                       ${AllChatFields.start_time} $textType,
                       ${AllChatFields.start_date} $textType
                     );
                    //create more table here
                
                ''');
    await db.execute('''
                  CREATE TABLE IF NOT EXISTS $tableSaveChat ( 
                       ${SaveChatsFields.id} $idType,
                       ${SaveChatsFields.t_id} $textType,
                       ${SaveChatsFields.msg} $textType,
                       ${SaveChatsFields.chatIndex} $integerType,
                       ${SaveChatsFields.isSelected} $boolType
                     );
                    //create more table here
                
                ''');

    //table students will be created if there is no table 'students'
    print("Table Created");
  }

  Future<AllChatModel> treadCreate(AllChatModel allChatModel) async {
    final db = await instance.database;
    final id = await db.insert(tableTreads, allChatModel.toJson());
    return allChatModel.copy(id: id);
  }

  Future<SaveChatModel> saveChatsCreate(SaveChatModel saveChatModel) async {
    final db = await instance.database;
    final id = await db.insert(tableSaveChat, saveChatModel.toJson());
    return saveChatModel.copy(id: id);
  }

  Future<int> deleteTread({required int id}) async {
    final db = await instance.database;
    return db.delete(
      tableTreads,
      where: '${AllChatFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllSaveChat({required int id}) async {
    final db = await instance.database;
    return db.delete(
      tableSaveChat,
      where: '${SaveChatsFields.t_id} = ?',
      whereArgs: [id],
    );
  }

  Future<List<SaveChatModel>> readSaveChatById(int id) async {
    final db = await instance.database;

    final listData = await db.query(
      tableSaveChat,
      columns: SaveChatsFields.values,
      where: '${SaveChatsFields.t_id} = ?',
      whereArgs: [id],
    );
    // print("-=-=-maps.first[SaveChatsFields.msg]");
    // print(listData.first[SaveChatsFields.id]);
    if (listData.isNotEmpty) {
      // var data = SaveChatModel.listOfSaveChats(maps);
      // return data;
      List<SaveChatModel> returenListData = [];

      for (var list in listData) {
        returenListData.add(SaveChatModel(
          id: int.parse(list[SaveChatsFields.id].toString()),
          chatIndex: int.parse(list[SaveChatsFields.chatIndex].toString()),
          msg: list[SaveChatsFields.msg].toString(),
          t_id: list[SaveChatsFields.t_id].toString(),
          isSelected: list[SaveChatsFields.isSelected] == 1,
          /* date: list[SaveChatsFields.date].toString(),
            time: list[SaveChatsFields.time].toString()*/
        ));
      }
      return returenListData;
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<AllChatModel>> readAllTreads(String id) async {
    final db = await instance.database;

    final orderBy = '${AllChatFields.start_date} ASC';

    final result = await db.query(tableTreads,
        orderBy: orderBy, where: '${AllChatFields.u_id} = ?', whereArgs: [id]);

    return result.map((json) => AllChatModel.fromJson(json)).toList();
  }

  Future<List<SaveChatModel>> readAllChats() async {
    final db = await instance.database;

    // final orderBy = '${NoteFields.time} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(
      tableSaveChat,
    );

    return result.map((json) => SaveChatModel.fromJson(json)).toList();
  }

  Future<int> deleteSaveChat(String id) async {
    final db = await instance.database;

    return await db.delete(
      tableSaveChat,
      where: '${SaveChatsFields.t_id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTreads(String id) async {
    final db = await instance.database;

    return await db.delete(
      tableTreads,
      where: '${AllChatFields.u_id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
