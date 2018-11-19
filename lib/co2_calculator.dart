
import 'package:flight_co2_calculator_flutter/flight_class.dart';

class _FlightParameters {
  _FlightParameters({
    this.a,
    this.b,
    this.c,
    this.S,
    this.PLF,
    this.DC,
    this.inv_CF,
    this.economyCW,
    this.businessCW,
    this.firstCW,
    this.EF,
    this.P,
    this.M,
  });

  final double a; // polynomial coefficient
  final double b; // polynomial coefficient
  final double c; // polynomial coefficient
  final double S; // average seat number
  final double PLF; // passenger load factor
  final double DC; // detour constant
  final double inv_CF; // 1 - cargo factor
  final double economyCW; // economy class weight
  final double businessCW; // business class weight
  final double firstCW; // first class weight
  final double EF; // emission factor
  final double P; // Pre production
  final double M; // multiplier

  static _FlightParameters shortHaulParams = _FlightParameters(
      a: 3.87871E-05,
      b: 2.9866,
      c: 1263.42,
      S: 158.44,
      PLF: 0.77,
      DC: 50,
      inv_CF: 0.951,
      economyCW: 0.960,
      businessCW: 1.26,
      firstCW: 2.40,
      EF: 3.150,
      P: 0.51,
      M: 2);

  static _FlightParameters longHaulParams = _FlightParameters(
      a: 0.000134576,
      b: 6.1798,
      c: 3446.20,
      S: 280.39,
      PLF: 0.77,
      DC: 125,
      inv_CF: 0.951,
      economyCW: 0.800,
      businessCW: 1.54,
      firstCW: 2.40,
      EF: 3.150,
      P: 0.51,
      M: 2);
}

double _flightClassWeight(
    {FlightClass flightClass, double economy, double business, double first}) {
  switch (flightClass) {
    case FlightClass.economy:
      return economy;
    case FlightClass.business:
      return business;
    case FlightClass.first:
      return first;
  }
  return economy;
}

class CO2Calculator {
  static double _normalize(
      {double value, double lowerBound, double upperBound}) {
    return (value - lowerBound) / (upperBound - lowerBound);
  }

  static double _interpolate({double a, double b, double value}) {
    return b * value + a * (1 - value);
  }

  static _FlightParameters flightParameters({double distanceKm}) {
    double lowerBound = 1500.0;
    double upperBound = 2500.0;
    if (distanceKm <= lowerBound) {
      return _FlightParameters.shortHaulParams;
    }
    if (distanceKm >= upperBound) {
      return _FlightParameters.longHaulParams;
    }
    double normalizedDistance = _normalize(
        value: distanceKm, lowerBound: lowerBound, upperBound: upperBound);

    final s = _FlightParameters.shortHaulParams;
    final l = _FlightParameters.longHaulParams;

    return _FlightParameters(
        a: _interpolate(a: s.a, b: l.a, value: normalizedDistance),
        b: _interpolate(a: s.b, b: l.b, value: normalizedDistance),
        c: _interpolate(a: s.c, b: l.c, value: normalizedDistance),
        S: _interpolate(a: s.S, b: l.S, value: normalizedDistance),
        PLF: _interpolate(a: s.PLF, b: l.PLF, value: normalizedDistance),
        DC: _interpolate(a: s.DC, b: l.DC, value: normalizedDistance),
        inv_CF:
            _interpolate(a: s.inv_CF, b: l.inv_CF, value: normalizedDistance),
        economyCW: _interpolate(
            a: s.economyCW, b: l.economyCW, value: normalizedDistance),
        businessCW: _interpolate(
            a: s.businessCW, b: l.businessCW, value: normalizedDistance),
        firstCW:
            _interpolate(a: s.firstCW, b: l.firstCW, value: normalizedDistance),
        EF: _interpolate(a: s.EF, b: l.EF, value: normalizedDistance),
        P: _interpolate(a: s.P, b: l.P, value: normalizedDistance),
        M: _interpolate(a: s.M, b: l.M, value: normalizedDistance));
  }

  static double calculateCO2e(double distanceKm, FlightClass flightClass) {
    _FlightParameters fp = flightParameters(distanceKm: distanceKm);
    double x = distanceKm + fp.DC;
    double CW = _flightClassWeight(
      flightClass: flightClass,
      economy: fp.economyCW,
      business: fp.businessCW,
      first: fp.firstCW,
    );
    return (fp.a * x * x + fp.b * x + fp.c) /
        (fp.S * fp.PLF) *
        fp.inv_CF *
        CW *
        (fp.EF * fp.M + fp.P);
  }

  static double correctedDistanceKm(double distanceKm) {
    final fp = flightParameters(distanceKm: distanceKm);
    return distanceKm + fp.DC;
  }
}
