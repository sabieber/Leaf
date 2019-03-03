import 'package:sqflite/sqflite.dart';

final String tableWatering = "watering";
final String columnId = "_id";
final String columnYear = "year";
final String columnMonth = "month";
final String columnDay = "day";
final String columnPlant = "plant";
final String columnType = "type";

class Watering {
  Watering({this.year, this.month, this.day, this.plant, this.type});

  int id;
  int year;
  int month;
  int day;
  int plant;
  int type;

  Watering.fromMap(Map map) {
    id = map[columnId] as int;
    year = map[columnYear] as int;
    month = map[columnMonth] as int;
    day = map[columnDay] as int;
    plant = map[columnPlant] as int;
    type = map[columnType] as int;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnYear: year,
      columnMonth: month,
      columnDay: day,
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
  WateringProvider(this.db);

  Database db;

  Future<Watering> insert(Watering watering) async {
    watering.id = await db.insert(tableWatering, watering.toMap());
    return watering;
  }

  Future<Watering> get(int id) async {
    List<Map> maps = await db.query(
      tableWatering,
      columns: [
        columnId,
        columnYear,
        columnMonth,
        columnDay,
        columnPlant,
        columnType
      ],
      where: "$columnId = ?",
      whereArgs: [id],
    );
    if (maps.length > 0) {
      return Watering.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Watering>> getAll() async {
    List<Map> maps = await db.query(
      tableWatering,
      columns: [
        columnId,
        columnYear,
        columnMonth,
        columnDay,
        columnPlant,
        columnType
      ],
    );
    return maps.map((map) {
      return Watering.fromMap(map);
    }).toList();
  }

  Future<List<Watering>> getAllForMonth(DateTime date) async {
    List<Map> maps = await db.query(
      tableWatering,
      where: "$columnYear = ? AND $columnMonth = ?",
      whereArgs: [date.year, date.month],
      columns: [
        columnId,
        columnYear,
        columnMonth,
        columnDay,
        columnPlant,
        columnType
      ],
    );
    return maps.map((map) {
      return Watering.fromMap(map);
    }).toList();
  }

  Future<List<Watering>> getAllForDate(DateTime date) async {
    List<Map> maps = await db.query(
      tableWatering,
      where: "$columnYear = ? AND $columnMonth = ? AND $columnDay = ?",
      whereArgs: [date.year, date.month, date.day],
      columns: [
        columnId,
        columnYear,
        columnMonth,
        columnDay,
        columnPlant,
        columnType
      ],
    );
    return maps.map((map) {
      return Watering.fromMap(map);
    }).toList();
  }

  Future<int> deleteById(int id) async {
    return await db.delete(
      tableWatering,
      where: "$columnId = ?",
      whereArgs: [id],
    );
  }

  Future<int> deleteByType(DateTime date, int plantId, int type) async {
    return await db.delete(
      tableWatering,
      where:
          "$columnYear = ? AND $columnMonth = ? AND $columnDay = ? AND $columnType = ? AND $columnPlant = ?",
      whereArgs: [date.year, date.month, date.day, type, plantId],
    );
  }

  Future<int> update(Watering watering) async {
    return await db.update(
      tableWatering,
      watering.toMap(),
      where: "$columnId = ?",
      whereArgs: [watering.id],
    );
  }

  Future close() async => db.close();
}
