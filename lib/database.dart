import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:plant_calendar/plant.dart';
import 'package:plant_calendar/watering.dart';
import 'package:sqflite/sqflite.dart';

Future<String> initDb(String dbName) async {
  var databasePath = await getDatabasesPath();
  String path = join(databasePath, dbName);

  if (!await Directory(dirname(path)).exists()) {
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (e) {
      print(e);
    }
  }
  return path;
}

Future<Database> openDb(String path) async {
  return await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    await db.execute('''
create table $tableWatering ( 
  $columnId integer primary key autoincrement, 
  $columnDate integer not null,
  $columnPlant integer not null,
  $columnType integer not null,
  FOREIGN KEY($columnPlant) REFERENCES $tablePlant($columnId))
''');
    await db.execute('''
create table $tablePlant ( 
  $columnPlantId integer primary key autoincrement, 
  $columnName text not null,
  $columnColor integer not null)
''');
  });
}
