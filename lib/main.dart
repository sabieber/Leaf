import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_colorpicker/flutter_colorpicker.dart' show ColorPicker;
import 'package:plant_calendar/database.dart';
import 'package:plant_calendar/plant.dart';
import 'package:plant_calendar/watering.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pflanzen Kalender',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Pflanzen Kalender'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text(widget.title),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: CalendarCarousel<Watering>(
          onDayPressed: (DateTime date, List<Watering> events) {
            if (events.isEmpty) return;

            showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: events.map((watering) {
                      return new ListTile(
                        leading: new Icon(Icons.local_florist,
                            color: watering.plant.color),
                        title: new Text(watering.plant.name),
                      );
                    }).toList(),
                  );
                });
          },
          weekendTextStyle: TextStyle(
            color: Colors.green[700],
          ),
          weekdayTextStyle: TextStyle(
            color: Colors.green[700],
          ),
          todayButtonColor: Colors.green[400],
          todayBorderColor: Colors.green[700],
          markedDateIconMaxShown: 10,
          markedDatesMap: new EventList<Watering>(events: {
            new DateTime(2019, 01, 26): [
              new Watering(
                date: new DateTime(2019, 01, 26),
                plant: Plant('Monstera', Colors.red),
              ),
              new Watering(
                date: new DateTime(2019, 01, 26),
                plant: Plant('Gummibaum', Colors.blue),
              ),
            ]
          }),
          iconColor: Colors.black,
          thisMonthDayBorderColor: Colors.grey[300],
          weekFormat: false,
          height: 420.0,
          daysHaveCircularBorder: false,
          locale: "de",
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PlantsList()),
          );
        },
        backgroundColor: Colors.green[400],
        tooltip: 'Pflanzen verwalten',
        child: Icon(Icons.local_florist),
      ),
    );
  }
}

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

class PlantForm extends StatefulWidget {
  PlantForm(this.plant);

  final Plant plant;

  @override
  PlantFormState createState() => new PlantFormState();
}

class PlantFormState extends State<PlantForm> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  Color color;

  @override
  void initState() {
    super.initState();
    if (widget.plant != null) {
      nameController.text = widget.plant.name;
      color = widget.plant.color;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text(
            widget.plant.id != null ? 'Pflanze bearbeiten' : 'Pflanze anlegen'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(20.0),
        child: new Form(
          key: formKey,
          child: new ListView(
            children: <Widget>[
              new TextFormField(
                keyboardType: TextInputType.text,
                controller: nameController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Gebe bitte den Name deiner Pflanze an';
                  }
                },
                decoration: new InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: ColorPicker(
                  pickerColor: color,
                  enableLabel: false,
                  enableAlpha: false,
                  onColorChanged: (newColor) {
                    color = newColor;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (formKey.currentState.validate()) {
            String path = await initDb("app.db");
            PlantProvider provider = PlantProvider();
            await provider.open(path);

            if (widget.plant.id != null) {
              Plant plant = widget.plant;
              plant.name = nameController.text;
              plant.color = color;
              await provider.update(plant);
            } else {
              Plant plant = Plant(nameController.text, color);
              await provider.insert(plant);
            }

            Navigator.pop(context);
          }
        },
        label: Text('Speichern'),
        backgroundColor: Colors.green[400],
        icon: Icon(Icons.check),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
