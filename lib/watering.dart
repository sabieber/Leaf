import 'package:plant_calendar/plant.dart';
import 'package:sqflite/sqflite.dart';

final String tableWatering = "watering";
final String columnId = "_id";
final String columnDate = "date";
final String columnPlant = "plant";
final String columnType = "type";

class Watering {
  Watering({this.date, this.plant, this.type});

  int id;
  DateTime date;
  int plant;
  int type;

  Watering.fromMap(Map map) {
    id = map[columnId] as int;
    date = new DateTime.fromMicrosecondsSinceEpoch(map[columnDate] as int);
    plant = map[columnPlant] as int;
    type = map[columnType] as int;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnDate: date.millisecondsSinceEpoch,
      columnPlant: plant,
      columnType: type
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

class WateringProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableWatering ( 
  $columnId integer primary key autoincrement, 
  $columnDate text not null,
  $columnPlant integer not null,
  $columnType integer not null,
  FOREIGN KEY($columnPlant) REFERENCES $tablePlant($columnId))
''');
    });
  }

  Future<Watering> insert(Watering watering) async {
    watering.id = await db.insert(tableWatering, watering.toMap());
    return watering;
  }

  Future<Watering> get(int id) async {
    List<Map> maps = await db.query(tableWatering,
        columns: [columnId, columnDate, columnPlant, columnType],
        where: "$columnId = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Watering.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Watering>> getAll() async {
    List<Map> maps = await db.query(tableWatering,
        columns: [columnId, columnDate, columnPlant, columnType]);
    return maps.map((map) {
      return Watering.fromMap(map);
    }).toList();
  }

  Future<int> deleteById(int id) async {
    return await db
        .delete(tableWatering, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> deleteByType(DateTime date, int type) async {
    return await db.delete(tableWatering,
        where: "$columnDate = ? AND $columnType = ?",
        whereArgs: [date.millisecondsSinceEpoch, type]);
  }

  Future<int> update(Watering watering) async {
    return await db.update(tableWatering, watering.toMap(),
        where: "$columnId = ?", whereArgs: [watering.id]);
  }

  Future close() async => db.close();
}
