import 'package:flutter/material.dart';
import 'package:plant_calendar/plant.dart';
import 'package:plant_calendar/plants_list_page.dart';
import 'package:plant_calendar/tuple.dart';

class WateringBottomSheet extends StatefulWidget {
  @override
  WateringBottomSheetState createState() => new WateringBottomSheetState();
}

class WateringBottomSheetState extends State<WateringBottomSheet> {
  List<Tuple<int, int>> filters = <Tuple<int, int>>[];

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<Plant>>(
      future: fetchPlantsFromDatabase(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return new Column(
              mainAxisSize: MainAxisSize.min,
              children: snapshot.data.map((plant) {
                return new ListTile(
                  leading: new Icon(Icons.local_florist, color: plant.color),
                  title: new Text(plant.name),
                  subtitle: new Wrap(
                    spacing: 4.0,
                    runSpacing: -8.0,
                    children: [
                      new FilterChip(
                        label: Text('Gegossen'),
                        selected: filters.any((watering) {
                          return watering.first == plant.id &&
                              watering.second == 0;
                        }),
                        onSelected: (value) {
                          setState(() {
                            if (value) {
                              filters.add(new Tuple(plant.id, 0));
                            } else {
                              filters.removeWhere((watering) {
                                return watering.first == plant.id &&
                                    watering.second == 0;
                              });
                            }
                          });
                        },
                      ),
                      new FilterChip(
                        label: Text('Besprüht'),
                        selected: filters.any((watering) {
                          return watering.first == plant.id &&
                              watering.second == 1;
                        }),
                        onSelected: (value) {
                          setState(() {
                            if (value) {
                              filters.add(new Tuple(plant.id, 1));
                            } else {
                              filters.removeWhere((watering) {
                                return watering.first == plant.id &&
                                    watering.second == 1;
                              });
                            }
                          });
                        },
                      ),
                      new FilterChip(
                        label: Text('Gedüngt'),
                        selected: filters.any((watering) {
                          return watering.first == plant.id &&
                              watering.second == 2;
                        }),
                        onSelected: (value) {
                          setState(() {
                            if (value) {
                              filters.add(new Tuple(plant.id, 2));
                            } else {
                              filters.removeWhere((watering) {
                                return watering.first == plant.id &&
                                    watering.second == 2;
                              });
                            }
                          });
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
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
}
