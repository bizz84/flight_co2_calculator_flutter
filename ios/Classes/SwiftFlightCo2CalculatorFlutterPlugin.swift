import Flutter
import UIKit

public class SwiftFlightCo2CalculatorFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flight_co2_calculator_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftFlightCo2CalculatorFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
