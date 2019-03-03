import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:intl/intl.dart';
import 'package:plant_calendar/database.dart';
import 'package:plant_calendar/monstera_icons.dart';
import 'package:plant_calendar/plant.dart';
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
  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  DateTime visibleMonth;

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    visibleMonth = DateTime(now.year, now.month, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text('Leaf'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<List<Plant>>(
            future: fetchPlantsFromDatabase(),
            builder: (context, plants) {
              if (plants.hasData) {
                return FutureBuilder<List<Watering>>(
                    future: fetchWateringsFromDatabase(visibleMonth),
                    builder: (context, waterings) {
                      if (waterings.hasData) {
                        EventList<Watering> wateringData = EventList();
                        waterings.data.forEach((watering) {
                          wateringData.add(
                              new DateTime(
                                  watering.year, watering.month, watering.day),
                              watering);
                        });

                        var calendar = new CalendarCarousel<Watering>(
                          onDayPressed:
                              (DateTime date, List<Watering> waterings) {
                            showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return WateringBottomSheet(date: date);
                                }).whenComplete(() {
                              setState(() {});
                            });
                          },
                          markedDatesMap: wateringData,
                          markedDateShowIcon: false,
                          markedDateIconBuilder: (watering) {
                            var plantColor = plants.data
                                .firstWhere(
                                    (plant) => plant.id == watering.plant,
                                    orElse: () => null)
                                ?.color;
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 1.0),
                              color: plantColor ?? Colors.black,
                              height: 4.0,
                              width: 4.0,
                            );
                          },
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
                          thisMonthDayBorderColor: Colors.grey[300],
                          showHeader: false,
                          weekFormat: false,
                          height: 420.0,
                          daysHaveCircularBorder: false,
                          locale: "de",
                        );

                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              //custom icon without header
                              Container(
                                margin: EdgeInsets.only(
                                  top: 30.0,
                                  bottom: 16.0,
                                  left: 16.0,
                                  right: 16.0,
                                ),
                                child: new Row(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.chevron_left),
                                      onPressed: () {
                                        setState(() {
                                          visibleMonth = DateTime(
                                              visibleMonth.year,
                                              visibleMonth.month - 1,
                                              1);
                                        });
                                      },
                                    ),
                                    Expanded(
                                        child: Text(
                                      '${DateFormat.yMMMM('de').format(visibleMonth)}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontFamily: 'Satisfy',
                                      ),
                                    )),
                                    IconButton(
                                      icon: Icon(Icons.chevron_right),
                                      onPressed: () {
                                        setState(() {
                                          visibleMonth = DateTime(
                                              visibleMonth.year,
                                              visibleMonth.month + 1,
                                              1);
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 16.0),
                                child: calendar,
                              ), //
                            ],
                          ),
                        );
                      }
                      return Text("loading");
                    });
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
        child: Icon(Monstera.monstera),
      ),
    );
  }
}
