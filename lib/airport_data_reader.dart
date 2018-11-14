import 'package:flight_co2_calculator_flutter/airport.dart';
import 'package:flutter/services.dart' show rootBundle;

class AirportDataReader {
  static Future<List<Airport>> load(String path) async {
    final data = await rootBundle.loadString(path);
    return data.split('\n')
        .map((line) => Airport.fromLine(line))
        .where((airport) => airport != null)
        .toList();
  }
}
