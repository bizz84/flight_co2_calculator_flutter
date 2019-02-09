import 'package:flight_co2_calculator_flutter/airport.dart';
import 'package:flight_co2_calculator_flutter/airport_data_reader.dart';
import 'package:flight_co2_calculator_flutter/airport_lookup.dart';
import 'package:flight_co2_calculator_flutter_example/app/flight_page.dart';
import 'package:flight_co2_calculator_flutter_example/blocs/flight_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  final start = DateTime.now();
  List<Airport> airports = await AirportDataReader.load('data/airports.dat');
  final elapsed = DateTime.now().difference(start);
  print('Loaded airports data in $elapsed');
  runApp(MyApp(airportLookup: AirportLookup(airports: airports)));
}

class MyApp extends StatelessWidget {
  MyApp({this.airportLookup});
  final AirportLookup airportLookup;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight CO2 calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StatefulProvider<FlightDetailsBloc>(
        valueBuilder: (context) => FlightDetailsBloc(),
        onDispose: (context, bloc) => bloc.dispose(),
        child: FlightPage(airportLookup: airportLookup),
      ),
    );
  }
}
