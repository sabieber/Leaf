import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
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
  return DBHelper().getPlants();
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
                                builder: (context) => PlantForm()),
                          );
                        },
                      );
                    });
              } else {
                return new Text("Keine Pflanzen angelegt");
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
            MaterialPageRoute(builder: (context) => PlantForm()),
          );
        },
        backgroundColor: Colors.green[400],
        tooltip: 'Pflanze hinzufügen',
        child: Icon(Icons.add),
      ),
    );
  }
}

class PlantForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text("Pflanze bearbeiten"),
      ),
      body: new Container(
        padding: new EdgeInsets.all(20.0),
        child: new Form(
          key: new GlobalKey<FormState>(),
          child: new ListView(
            children: <Widget>[
              new TextFormField(
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          DBHelper().savePlant(new Plant('Test', Colors.green));
          Navigator.pop(context);
        },
        label: Text('Speichern'),
        backgroundColor: Colors.green[400],
        icon: Icon(Icons.check),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
