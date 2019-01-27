import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;

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

class Watering {
  final DateTime date;
  final Plant plant;

  Watering({this.date, this.plant}) : assert(date != null);
}

class Plant {
  final String name;
  final Color color;

  Plant({this.name, this.color});
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
            events.forEach((event) => print(event.plant));
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
                plant: Plant(
                  name: 'Monstera',
                  color: Colors.red,
                ),
              ),
              new Watering(
                date: new DateTime(2019, 01, 26),
                plant: Plant(
                  name: 'Gummibaum',
                  color: Colors.blue,
                ),
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

class PlantsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text("Pflanzen verwalten"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.local_florist, color: Colors.red),
            title: Text('Monstera'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlantForm()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.local_florist, color: Colors.blue),
            title: Text('Monkey Mask'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlantForm()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.local_florist, color: Colors.deepPurple),
            title: Text('Gummibaum'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlantForm()),
              );
            },
          ),
        ],
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PlantForm()),
          );
        },
        label: Text('Speichern'),
        backgroundColor: Colors.green[400],
        icon: Icon(Icons.check),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
