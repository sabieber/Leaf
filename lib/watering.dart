import 'package:plant_calendar/plant.dart';

class Watering {
  final DateTime date;
  final Plant plant;

  Watering({this.date, this.plant}) : assert(date != null);
}