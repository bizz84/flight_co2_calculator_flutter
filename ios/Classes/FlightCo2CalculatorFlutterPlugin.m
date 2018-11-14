#import "FlightCo2CalculatorFlutterPlugin.h"
#import <flight_co2_calculator_flutter/flight_co2_calculator_flutter-Swift.h>

@implementation FlightCo2CalculatorFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlightCo2CalculatorFlutterPlugin registerWithRegistrar:registrar];
}
@end
