import 'package:plant_calendar/plant.dart';

class Watering {
  final DateTime date;
  final Plant plant;
  final int type;

  Watering({this.date, this.plant, this.type}) : assert(date != null);
}
