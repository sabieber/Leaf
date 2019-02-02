import 'package:flutter/material.dart';
import 'package:plant_calendar/plant.dart';
import 'package:plant_calendar/plants_list_page.dart';

class WateringBottomSheet extends StatefulWidget {
  @override
  WateringBottomSheetState createState() => new WateringBottomSheetState();
}

class WateringBottomSheetState extends State<WateringBottomSheet> {
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
                    children: [
                      new FilterChip(
                        onSelected: (value) {},
                        label: Text('Gegossen'),
                      ),
                      new FilterChip(
                        onSelected: (value) {},
                        label: Text('Eingesprüht'),
                      ),
                      new FilterChip(
                        onSelected: (value) {},
                        label: Text('Gedüngt'),
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
