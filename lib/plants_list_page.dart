import 'package:flutter/material.dart';
import 'package:plant_calendar/database.dart';
import 'package:plant_calendar/plant.dart';
import 'package:plant_calendar/plant_form_page.dart';

Future<List<Plant>> fetchPlantsFromDatabase() async {
  String path = await initDb("app.db");
  PlantProvider provider = PlantProvider();
  await provider.open(path);
  return provider.getAll();
}

class PlantsList extends StatefulWidget {
  @override
  PlantsListState createState() => new PlantsListState();
}

class PlantsListState extends State<PlantsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text("Pflanzen verwalten"),
      ),
      body: new Container(
        padding: new EdgeInsets.all(16.0),
        child: new FutureBuilder<List<Plant>>(
          future: fetchPlantsFromDatabase(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                return new ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.local_florist,
                            color: snapshot.data[index].color),
                        title: Text(snapshot.data[index].name),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PlantForm(snapshot.data[index])),
                          );
                        },
                      );
                    });
              } else {
                return new Center(child: new Text("Keine Pflanzen angelegt"));
              }
            }
            return new Container(
              alignment: AlignmentDirectional.center,
              child: new CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlantForm(new Plant(null, Colors.green))),
          );
        },
        backgroundColor: Colors.green[400],
        tooltip: 'Pflanze hinzufügen',
        child: Icon(Icons.add),
      ),
    );
  }
}
