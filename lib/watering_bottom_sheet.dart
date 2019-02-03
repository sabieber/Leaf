import 'package:flutter/material.dart';
import 'package:plant_calendar/database.dart';
import 'package:plant_calendar/plant.dart';
import 'package:plant_calendar/plants_list_page.dart';
import 'package:plant_calendar/tuple.dart';
import 'package:plant_calendar/watering.dart';
import 'package:sqflite/sqflite.dart';

Future<List<Watering>> fetchWateringsFromDatabase(DateTime date) async {
  String path = await initDb("app.db");
  Database db = await openDb(path);
  WateringProvider provider = WateringProvider(db);
  return provider.getAllForDate(date);
}

class WateringBottomSheet extends StatefulWidget {
  WateringBottomSheet({Key key, this.date}) : super(key: key);

  final DateTime date;

  @override
  WateringBottomSheetState createState() => new WateringBottomSheetState();
}

class WateringBottomSheetState extends State<WateringBottomSheet> {
  List<Tuple<int, int>> filters = <Tuple<int, int>>[];

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<Plant>>(
      future: fetchPlantsFromDatabase(),
      builder: (context, plants) {
        if (plants.hasData) {
          if (plants.data.length > 0) {
            return new FutureBuilder<List<Watering>>(
              future: fetchWateringsFromDatabase(widget.date),
              builder: (context, waterings) {
                if (waterings.hasData) {
                  return new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: plants.data.map((plant) {
                      return createPlantListTile(plant, waterings.data);
                    }).toList(),
                  );
                }
                return new Container(
                  alignment: AlignmentDirectional.center,
                  child: new CircularProgressIndicator(),
                );
              },
            );
          } else {
            return new Center(child: new Text("Keine Pflanzen angelegt"));
          }
        }
        return new Container(
          alignment: AlignmentDirectional.center,
          child: new CircularProgressIndicator(),
        );
      },
    );
  }

  ListTile createPlantListTile(Plant plant, List<Watering> waterings) {
    return new ListTile(
      leading: new Icon(Icons.local_florist, color: plant.color),
      title: new Text(plant.name),
      subtitle: new Wrap(
        spacing: 4.0,
        runSpacing: -8.0,
        children: [
          new FilterChip(
            label: Text('Gegossen'),
            selected: waterings?.any((watering) {
                  return watering.plant == plant.id && watering.type == 0;
                }) ??
                false,
            onSelected: (value) async {
              String path = await initDb("app.db");
              Database db = await openDb(path);
              WateringProvider provider = WateringProvider(db);

              if (value) {
                provider.insert(
                    new Watering(date: widget.date, plant: plant.id, type: 0));
              } else {
                provider.deleteByType(widget.date, 0);
              }
            },
          ),
          new FilterChip(
            label: Text('Besprüht'),
            selected: waterings?.any((watering) {
                  return watering.plant == plant.id && watering.type == 1;
                }) ??
                false,
            onSelected: (value) {
              setState(() {
                if (value) {
                  filters.add(new Tuple(plant.id, 1));
                } else {
                  filters.removeWhere((watering) {
                    return watering.first == plant.id && watering.second == 1;
                  });
                }
              });
            },
          ),
          new FilterChip(
            label: Text('Gedüngt'),
            selected: waterings?.any((watering) {
                  return watering.plant == plant.id && watering.type == 1;
                }) ??
                false,
            onSelected: (value) {
              setState(() {
                if (value) {
                  filters.add(new Tuple(plant.id, 2));
                } else {
                  filters.removeWhere((watering) {
                    return watering.first == plant.id && watering.second == 2;
                  });
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
