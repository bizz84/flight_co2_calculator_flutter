

import 'dart:math';

import 'package:flight_co2_calculator_flutter/airport.dart';

class DistanceCalculator {

  // distance in meters to another location
  // http://stackoverflow.com/questions/12966638/how-to-calculate-the-distance-between-two-gps-coordinates-without-using-google-m
  static double distanceInMetersBetween(LocationCoordinate2D lhs, LocationCoordinate2D rhs) {

    double rad_per_deg = pi / 180.0;  // PI / 180
    double rkm = 6371.0;// Earth radius in kilometers
    double rm = rkm * 1000.0;// Radius in meters

    double dlat_rad = (rhs.latitude - lhs.latitude) * rad_per_deg; // Delta, converted to rad
    double dlon_rad = (rhs.longitude - lhs.longitude) * rad_per_deg;

    double lat1_rad = lhs.latitude * rad_per_deg;
    double lat2_rad = rhs.latitude * rad_per_deg;

    double sinDlat = sin(dlat_rad/2);
    double sinDlon = sin(dlon_rad/2);

    double a = sinDlat * sinDlat + cos(lat1_rad) * cos(lat2_rad) * sinDlon * sinDlon;
    double c = 2.0 * atan2(sqrt(a), sqrt(1-a));
    return rm * c;
  }

  static double distanceInKmBetween(LocationCoordinate2D lhs, LocationCoordinate2D rhs) {
    return distanceInMetersBetween(lhs, rhs) / 1000.0;
  }
}