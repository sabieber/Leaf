import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

final String tablePlant = "plant";
final String columnPlantId = "_id";
final String columnName = "name";
final String columnColor = "color";
final String columnOrder = "order";

class Plant {
  Plant(this.name, this.color);

  Plant.fromMap(Map map) {
    id = map[columnPlantId] as int;
    name = map[columnName] as String;
    color = new Color(map[columnColor]);
  }

  int id;
  String name;
  Color color;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{columnName: name, columnColor: color.value};
    if (id != null) {
      map[columnPlantId] = id;
    }
    return map;
  }
}

class PlantProvider {
  PlantProvider(this.db);

  Database db;

  Future<Plant> insert(Plant todo) async {
    todo.id = await db.insert(tablePlant, todo.toMap());
    return todo;
  }

  Future<Plant> get(int id) async {
    List<Map> maps = await db.query(tablePlant,
        columns: [columnPlantId, columnName, columnColor],
        where: "$columnPlantId = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Plant.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Plant>> getAll() async {
    List<Map> maps = await db
        .query(tablePlant, columns: [columnPlantId, columnName, columnColor]);
    return maps.map((map) {
      return Plant.fromMap(map);
    }).toList();
  }

  Future<int> delete(int id) async {
    return await db
        .delete(tablePlant, where: "$columnPlantId = ?", whereArgs: [id]);
  }

  Future<int> update(Plant todo) async {
    return await db.update(tablePlant, todo.toMap(),
        where: "$columnPlantId = ?", whereArgs: [todo.id]);
  }

  Future close() async => db.close();
}
