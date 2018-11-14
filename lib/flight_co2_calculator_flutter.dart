import 'dart:async';

import 'package:flutter/services.dart';

class FlightCo2CalculatorFlutter {
  static const MethodChannel _channel =
      const MethodChannel('flight_co2_calculator_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
