import 'package:flutter/material.dart';
import 'package:plant_calendar/calendar_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pflanzen Kalender',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Montserrat',
      ),
      home: Calendar(title: 'Pflanzen Kalender'),
    );
  }
}
