import 'dart:async';

import 'package:flight_co2_calculator_flutter/airport.dart';
import 'package:flight_co2_calculator_flutter/flight_class.dart';
import 'package:flight_co2_calculator_flutter_example/blocs/bloc_provider.dart';
import 'package:flight_co2_calculator_flutter/distance_calculator.dart';
import 'package:flight_co2_calculator_flutter/co2_calculator.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

/// Flight type: one way or return
enum FlightType {
  oneWay,
  twoWays,
}

/// Model for the FlightDetailsCard
class FlightDetails {
  FlightDetails({
    this.departure,
    this.arrival,
    this.flightClass = FlightClass.economy,
    this.flightType = FlightType.oneWay,
  });
  final Airport departure;
  final Airport arrival;
  final FlightClass flightClass;
  final FlightType flightType;

  FlightDetails copyWith(
      {Airport departure,
      Airport arrival,
      FlightClass flightClass,
      FlightType flightType}) {
    return FlightDetails(
      departure: departure ?? this.departure,
      arrival: arrival ?? this.arrival,
      flightClass: flightClass ?? this.flightClass,
      flightType: flightType ?? this.flightType,
    );
  }
}

/// Model for the FlightCalculationCard
class FlightData {
  FlightData({this.distanceKm, this.co2e});
  final double distanceKm;
  final double co2e;

  /// factory method to calculate the distance and co2 from the flight details
  factory FlightData.fromDetails(FlightDetails flightDetails) {
    double distanceKm;
    double co2e;
    Airport departure = flightDetails.departure;
    Airport arrival = flightDetails.arrival;
    if (departure != null && arrival != null) {
      double multiplier =
          flightDetails.flightType == FlightType.oneWay ? 1.0 : 2.0;
      distanceKm = DistanceCalculator.distanceInKmBetween(
          departure.location, arrival.location);
      distanceKm = CO2Calculator.correctedDistanceKm(distanceKm);
      co2e =
          CO2Calculator.calculateCO2e(distanceKm, flightDetails.flightClass) *
              multiplier;
    }
    return FlightData(distanceKm: distanceKm, co2e: co2e);
  }
}

/// Model for the FlightPage
class Flight {
  Flight({@required this.details, @required this.data});
  final FlightDetails details;
  final FlightData data;

  /// Initial empty data to be used as the seed value for the stream
  factory Flight.initialData() {
    return Flight(
      details: FlightDetails(),
      data: FlightData(),
    );
  }

  Flight copyWith({
    Airport departure,
    Airport arrival,
    FlightClass flightClass,
    FlightType flightType,
  }) {
    // get existing details and update
    FlightDetails flightDetails = details.copyWith(
      departure: departure,
      arrival: arrival,
      flightClass: flightClass,
      flightType: flightType,
    );
    // calculate corresponding data
    FlightData flightData = FlightData.fromDetails(flightDetails);
    // return new object
    return Flight(
      details: flightDetails,
      data: flightData,
    );
  }
}

/// Bloc used by the FlightPage
class FlightDetailsBloc implements BlocBase {
  BehaviorSubject _flightSubject = BehaviorSubject<Flight>(
    seedValue: Flight.initialData(),
  );
  Stream<Flight> get flightStream => _flightSubject.controller.stream;

  void updateWith({
    Airport departure,
    Airport arrival,
    FlightClass flightClass,
    FlightType flightType,
  }) {
    // get new value by updating existing one
    Flight newValue = _flightSubject.value.copyWith(
      departure: departure,
      arrival: arrival,
      flightClass: flightClass,
      flightType: flightType,
    );
    // add back to the stream
    _flightSubject.add(newValue);
  }

  dispose() {
    _flightSubject.close();
  }
}
