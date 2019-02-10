import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:intl/intl.dart';
import 'package:plant_calendar/database.dart';
import 'package:plant_calendar/plants_list_page.dart';
import 'package:plant_calendar/watering.dart';
import 'package:plant_calendar/watering_bottom_sheet.dart';
import 'package:sqflite/sqflite.dart';

Future<List<Watering>> fetchWateringsFromDatabase(DateTime month) async {
  Database db = await openDb();
  WateringProvider provider = WateringProvider(db);
  return provider.getAllForMonth(month);
}

class Calendar extends StatefulWidget {
  Calendar({Key key, this.title}) : super(key: key);

  final String title;

  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  DateTime visibleMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text(widget.title),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<List<Watering>>(
            future: fetchWateringsFromDatabase(visibleMonth),
            builder: (context, waterings) {
              if (waterings.hasData) {
                EventList<Watering> wateringData = EventList();
                waterings.data.forEach((watering) {
                  wateringData.add(
                      new DateTime(watering.year, watering.month, watering.day),
                      watering);
                });

                return new CalendarCarousel<Watering>(
                  onDayPressed: (DateTime date, List<Watering> waterings) {
                    showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return WateringBottomSheet(date: date);
                        });
                  },
                  onCalendarChanged: (DateTime date) {
                    setState(() {
                      visibleMonth = date;
                    });
                  },
                  markedDatesMap: wateringData,
                  headerText: Text(
                    '${DateFormat.yMMMM('de').format(visibleMonth)}',
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'Satisfy',
                    ),
                  ),
                  prevDaysTextStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                  ),
                  daysTextStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                  ),
                  todayTextStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                  ),
                  weekendTextStyle: TextStyle(
                    color: Colors.green[700],
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                  ),
                  nextDaysTextStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                  ),
                  weekdayTextStyle: TextStyle(
                    color: Colors.green[700],
                    fontFamily: 'Montserrat',
                  ),
                  todayButtonColor: Colors.green[400],
                  todayBorderColor: Colors.green[700],
                  markedDateIconMaxShown: 10,
                  iconColor: Colors.black,
                  thisMonthDayBorderColor: Colors.grey[300],
                  weekFormat: false,
                  height: 420.0,
                  daysHaveCircularBorder: false,
                  locale: "de",
                );
              }
              return Text("loading");
            }),
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
