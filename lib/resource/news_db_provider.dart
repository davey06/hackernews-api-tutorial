import 'package:news_sqlite/model/item_model.dart';
import 'package:news_sqlite/resource/repo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';

final dbItemTable = "Items";

class NewsdbProvider implements Source, Cache {
  Database db;

  NewsdbProvider() {
    init();
  }

  init() async {
    Directory docDirectory = await getApplicationDocumentsDirectory();
    final path = join(docDirectory.path, "items.db");
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        newDb.execute('''
          CREATE TABLE $dbItemTable
            (
              id INTEGER PRIMARY KEY,
              deleted INTEGER ,
              type TEXT ,
              by TEXT ,
              time INTEGER ,
              text TEXT ,
              dead INTEGER ,
              parent INTEGER ,
              kids BLOB ,
              url TEXT ,
              score INTEGER ,
              title TEXT ,
              descendants INTEGER
            )
        ''');
      },
    );
  }

  //TODO: Store TopIds to Db
  Future<List<int>> fetchTopIds() {
    return null;
  }

  Future<ItemModel> fetchItem(int id) async {
    final mapItem = await db.query(
      dbItemTable,
      columns: null,
      where: "id = ?",
      whereArgs: [id],
    );

    if (mapItem.length > 0) {
      return ItemModel.fromDb(mapItem.first);
    }
    return null;
  }

  Future<int> addItem(ItemModel item) {
    db.insert(dbItemTable, item.toMapforDb(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<int> clear() {
    db.delete(dbItemTable);
  }
}
