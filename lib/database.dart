import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
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
