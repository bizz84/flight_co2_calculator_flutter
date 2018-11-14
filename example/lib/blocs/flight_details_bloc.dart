import 'dart:async';

import 'package:flight_co2_calculator_flutter/airport.dart';
import 'package:flight_co2_calculator_flutter/flight_class.dart';
import 'package:flight_co2_calculator_flutter_example/blocs/bloc_provider.dart';
import 'package:flight_co2_calculator_flutter/distance_calculator.dart';
import 'package:flight_co2_calculator_flutter/co2_calculator.dart';
import 'package:rxdart/rxdart.dart';

enum FlightType {
  oneWay,
  twoWays,
}

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

class FlightCalculationData {
  FlightCalculationData({this.distanceKm, this.co2e});
  final double distanceKm;
  final double co2e;
}

class Flight {
  Flight({this.details, this.data});
  final FlightDetails details;
  final FlightCalculationData data;

  factory Flight.initialValue() {
    return Flight(
      details: FlightDetails(),
      data: FlightCalculationData(),
    );
  }
}

class FlightDetailsBloc implements BlocBase {
  BehaviorSubject _flightSubject =
      BehaviorSubject<Flight>(seedValue: Flight.initialValue());
  Stream<Flight> get flightStream => _flightSubject.controller.stream;
  Flight get flight => _flightSubject.value;

  // public methods
  void updateDeparture(Airport departure) {
    _updateWith(departure: departure);
  }

  void updateArrival(Airport arrival) {
    _updateWith(arrival: arrival);
  }

  void updateFlightClass(FlightClass flightClass) {
    _updateWith(flightClass: flightClass);
  }

  void updateFlightType(FlightType flightType) {
    _updateWith(flightType: flightType);
  }

  // private methods
  void _updateWith({
    Airport departure,
    Airport arrival,
    FlightClass flightClass,
    FlightType flightType,
  }) {
    FlightDetails flightDetails = flight.details.copyWith(
      departure: departure,
      arrival: arrival,
      flightClass: flightClass,
      flightType: flightType,
    );
    FlightCalculationData flightCalculationData = _calculate(flightDetails);
    _flightSubject.add(Flight(
      details: flightDetails,
      data: flightCalculationData,
    ));
  }

  FlightCalculationData _calculate(FlightDetails flightDetails) {
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
    return FlightCalculationData(distanceKm: distanceKm, co2e: co2e);
  }

  dispose() {
    _flightSubject.close();
  }
}
