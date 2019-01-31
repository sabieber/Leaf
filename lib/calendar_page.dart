import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:plant_calendar/plant.dart';
import 'package:plant_calendar/plants_list_page.dart';
import 'package:plant_calendar/watering.dart';

class Calendar extends StatefulWidget {
  Calendar({Key key, this.title}) : super(key: key);

  final String title;

  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
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
          onDayPressed: (DateTime date, List<Watering> waterings) {
            showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return new FutureBuilder<List<Plant>>(
                    future: fetchPlantsFromDatabase(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.length > 0) {
                          return new Column(
                            mainAxisSize: MainAxisSize.min,
                            children: snapshot.data.map((plant) {
                              return new ListTile(
                                leading: new Icon(Icons.local_florist,
                                    color: plant.color),
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
                                      label: Text('Gedüngt'),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        } else {
                          return new Center(
                              child: new Text("Keine Pflanzen angelegt"));
                        }
                      }
                      return new Container(
                        alignment: AlignmentDirectional.center,
                        child: new CircularProgressIndicator(),
                      );
                    },
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
                plant: Plant('Monstera', Colors.red)..id = 1,
              ),
              new Watering(
                date: new DateTime(2019, 01, 26),
                plant: Plant('Gummibaum', Colors.blue)..id = 2,
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
