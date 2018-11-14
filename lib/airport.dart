import 'package:flutter/foundation.dart';

/*

 From: http://openflights.org/data.html

 Airport ID	Unique OpenFlights identifier for this airport.
 Name	Name of airport. May or may not contain the City name.
 City	Main city served by airport. May be spelled differently from Name.
 Country	Country or territory where airport is located. See countries.dat to cross-reference to ISO 3166-1 codes.
 IATA	3-letter IATA code. Null if not assigned/unknown.
 ICAO	4-letter ICAO code.
 Null if not assigned.
 Latitude	Decimal degrees, usually to six significant digits. Negative is South, positive is North.
 Longitude	Decimal degrees, usually to six significant digits. Negative is West, positive is East.
 Altitude	In feet.
 Timezone	Hours offset from UTC. Fractional hours are expressed as decimals, eg. India is 5.5.
 DST	Daylight savings time. One of E (Europe), A (US/Canada), S (South America), O (Australia), Z (New Zealand), N (None) or U (Unknown). See also: Help: Time
 Tz database time zone	Timezone in "tz" (Olson) format, eg. "America/Los_Angeles".
 Type	Type of the airport. Value "airport" for air terminals, "station" for train stations, "port" for ferry terminals and "unknown" if not known. In airports.csv, only type=airport is included.
 Source	Source of this data. "OurAirports" for data sourced from OurAirports, "Legacy" for old data not matched to OurAirports (mostly DAFIF), "User" for unverified user contributions. In airports.csv, only source=OurAirports is included.
 The data is UTF-8 (Unicode) encoded.

 */

class LocationCoordinate2D {
  LocationCoordinate2D({this.latitude, this.longitude});
  final double latitude;
  final double longitude;

  @override
  String toString() {
    return "($latitude, $longitude)";
  }
}

class Airport implements Comparable {
  Airport({
    @required this.name,
    @required this.city,
    @required this.country,
    this.iata,
    this.icao,
    @required this.location,
  });
  //int airportID
  final String name;
  final String city;
  final String country;
  final String iata;
  final String icao;
  final LocationCoordinate2D location;
  //final double latitude;
  //final double longitude;
  //final double altitude;
  //final double timezone;
  //final String dst;
  //final String tzDatabaseTimeZone;
  //final String type; // = "airport"
  //final String source; // = "OurAirports"

  factory Airport.fromLine(String line) {
    final components = line.split(",");
    if (components.length < 8) {
      return null;
    }
    String name = unescapeString(components[1]);
    String city = unescapeString(components[2]);
    String country = unescapeString(components[3]);
    String iata = unescapeString(components[4]);
    if (iata == '\\N') {
      iata = null;
    }
    String icao = unescapeString(components[5]);
    try {
      double latitude = double.parse(unescapeString(components[6]));
      double longitude = double.parse(unescapeString(components[7]));
      final location = LocationCoordinate2D(
          latitude: latitude, longitude: longitude);
      return Airport(
        name: name,
        city: city,
        country: country,
        iata: iata,
        icao: icao,
        location: location,
      );
    } catch (e) {
      try {
        // sometimes, components[6] is a String and the lat-long are stored
        // at index 7 and 8
        double latitude = double.parse(unescapeString(components[7]));
        double longitude = double.parse(unescapeString(components[8]));
        final location = LocationCoordinate2D(
            latitude: latitude, longitude: longitude);
        return Airport(
          name: name,
          city: city,
          country: country,
          iata: iata,
          location: location,
        );
      } catch (e) {
        print(e);
        return null;
      }
    }
  }

  static String unescapeString(dynamic value) {
    if (value is String) {
      return value.replaceAll('"', '');
    }
    return null;
  }

  @override
  int get hashCode => iata.hashCode;

  @override
  bool operator ==(other) {
    return iata == other.iata;
  }

  @override
  int compareTo(other) {
    return iata.hashCode - other.hashCode;
  }

  @override
  String toString() {
    return "($iata, $icao) -> $name, $city, $country, ${location.toString()}";
  }
}
