import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plant_calendar/plant.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "app.db");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Plant(id INTEGER PRIMARY KEY, name TEXT, color INTEGER)");
  }

  // Retrieving employees from Employee Tables
  Future<List<Plant>> getPlants() async {
    var client = await db;
    List<Map> list = await client.rawQuery('SELECT * FROM Plant');
    List<Plant> plants = new List();
    for (int i = 0; i < list.length; i++) {
      plants.add(new Plant(list[i]["name"], new Color(list[i]["color"])));
    }
    return plants;
  }

  void savePlant(Plant plant) async {
    var client = await db;
    await client.transaction((txn) async {
      return await txn.rawInsert('INSERT INTO Plant(name, color) VALUES(' +
          '\'' +
          plant.name +
          '\'' +
          ',' +
          '\'' +
          plant.color.value.toString() +
          '\'' +
          ')');
    });
  }
}
