import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

final String tablePlant = "plant";
final String columnId = "_id";
final String columnName = "name";
final String columnColor = "color";

class Plant {
  Plant(this.name, this.color);

  Plant.fromMap(Map map) {
    id = map[columnId] as int;
    name = map[columnName] as String;
    color = new Color(map[columnColor]);
  }

  int id;
  String name;
  Color color;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{columnName: name, columnColor: color.value};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

class PlantProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tablePlant ( 
  $columnId integer primary key autoincrement, 
  $columnName text not null,
  $columnColor integer not null)
''');
    });
  }

  Future<Plant> insert(Plant todo) async {
    todo.id = await db.insert(tablePlant, todo.toMap());
    return todo;
  }

  Future<Plant> get(int id) async {
    List<Map> maps = await db.query(tablePlant,
        columns: [columnId, columnName, columnColor],
        where: "$columnId = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Plant.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Plant>> getAll() async {
    List<Map> maps = await db.query(tablePlant,
        columns: [columnId, columnName, columnColor]);
    return maps.map((map) {
      return Plant.fromMap(map);
    }).toList();
  }

  Future<int> delete(int id) async {
    return await db.delete(tablePlant, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> update(Plant todo) async {
    return await db.update(tablePlant, todo.toMap(),
        where: "$columnId = ?", whereArgs: [todo.id]);
  }

  Future close() async => db.close();
}
