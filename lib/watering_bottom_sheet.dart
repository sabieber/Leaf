import 'package:flutter/material.dart';
import 'package:plant_calendar/database.dart';
import 'package:plant_calendar/monstera_icons.dart';
import 'package:plant_calendar/plant.dart';
import 'package:plant_calendar/plants_list_page.dart';
import 'package:plant_calendar/tuple.dart';
import 'package:plant_calendar/watering.dart';
import 'package:sqflite/sqflite.dart';

Future<List<Watering>> fetchWateringsFromDatabase(DateTime date) async {
  Database db = await openDb();
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
                  return new ListView(
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
      leading: new Icon(Monstera.monstera, color: plant.color),
      title: new Text(plant.name),
      subtitle: new Wrap(
        spacing: 4.0,
        runSpacing: -8.0,
        children: [
          new FilterChip(
            label: Text(
              'Gießen',
              textScaleFactor: 0.8,
            ),
            selected: waterings?.any((watering) {
                  return watering.plant == plant.id && watering.type == 0;
                }) ??
                false,
            onSelected: (value) async {
              Database db = await openDb();
              WateringProvider provider = WateringProvider(db);

              if (value) {
                provider.insert(new Watering(
                    year: widget.date.year,
                    month: widget.date.month,
                    day: widget.date.day,
                    plant: plant.id,
                    type: 0));
              } else {
                provider.deleteByType(widget.date, plant.id, 0);
              }
              setState(() {});
            },
          ),
          new FilterChip(
            label: Text(
              'Einsprühen',
              textScaleFactor: 0.8,
            ),
            selected: waterings?.any((watering) {
                  return watering.plant == plant.id && watering.type == 1;
                }) ??
                false,
            onSelected: (value) async {
              Database db = await openDb();
              WateringProvider provider = WateringProvider(db);

              if (value) {
                provider.insert(new Watering(
                    year: widget.date.year,
                    month: widget.date.month,
                    day: widget.date.day,
                    plant: plant.id,
                    type: 1));
              } else {
                provider.deleteByType(widget.date, plant.id, 1);
              }
              setState(() {});
            },
          ),
          new FilterChip(
            label: Text(
              'Düngen',
              textScaleFactor: 0.8,
            ),
            selected: waterings?.any((watering) {
                  return watering.plant == plant.id && watering.type == 2;
                }) ??
                false,
            onSelected: (value) async {
              Database db = await openDb();
              WateringProvider provider = WateringProvider(db);

              if (value) {
                provider.insert(new Watering(
                    year: widget.date.year,
                    month: widget.date.month,
                    day: widget.date.day,
                    plant: plant.id,
                    type: 2));
              } else {
                provider.deleteByType(widget.date, plant.id, 2);
              }
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
