import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:plant_calendar/plant.dart';
import 'package:plant_calendar/plants_list_page.dart';
import 'package:plant_calendar/watering.dart';
import 'package:plant_calendar/watering_bottom_sheet.dart';

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
                  return WateringBottomSheet();
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
            new DateTime(2019, 02, 20): [
              new Watering(
                date: new DateTime(2019, 02, 20),
                plant: Plant('Monstera', Colors.red)..id = 1,
              ),
              new Watering(
                date: new DateTime(2019, 02, 20),
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
