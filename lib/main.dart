import 'package:flutter/material.dart';
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
        child: CalendarCarousel(
          weekendTextStyle: TextStyle(
            color: Colors.green[700],
          ),
          weekdayTextStyle: TextStyle(
            color: Colors.green[700],
          ),
          todayButtonColor: Colors.green[400],
          todayBorderColor: Colors.green[700],
          iconColor: Colors.black,
          thisMonthDayBorderColor: Colors.grey[300],
          weekFormat: false,
          height: 420.0,
          daysHaveCircularBorder: false,
          locale: "de",
        ),
      ),
    );
  }
}