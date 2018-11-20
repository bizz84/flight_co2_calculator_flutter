import 'package:auto_size_text/auto_size_text.dart';
import 'package:flight_co2_calculator_flutter/airport_lookup.dart';
import 'package:flight_co2_calculator_flutter_example/app/constants/palette.dart';
import 'package:flight_co2_calculator_flutter_example/app/constants/text_styles.dart';
import 'package:flight_co2_calculator_flutter_example/app/flight_calculation_card.dart';
import 'package:flight_co2_calculator_flutter_example/app/flight_details_card.dart';
import 'package:flight_co2_calculator_flutter_example/blocs/bloc_provider.dart';
import 'package:flight_co2_calculator_flutter_example/blocs/flight_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class FlightPage extends StatelessWidget {
  FlightPage({this.airportLookup});
  final AirportLookup airportLookup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.blueSky,
        title: Text('Flight CO2 Calculator'),
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    final flightDetailsBloc = BlocProvider.of<FlightDetailsBloc>(context);
    return StreamBuilder<Flight>(
      stream: flightDetailsBloc.flightStream,
      initialData: Flight.initialData(),
      builder: (context, snapshot) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Palette.blueSky,
                Palette.blueGreen,
                Palette.greenLand,
              ],
            ),
          ),
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                FlightDetailsCard(
                  airportLookup: airportLookup,
                  flightDetails: snapshot.data.details,
                ),
                FlightCalculationCard(
                  flightCalculationData: snapshot.data.data,
                ),
                Expanded(child: Container()),
                AutoSizeText(
                  'Flight CO2 calculation formula by myclimate.org',
                  minFontSize: 11.0,
                  maxLines: 1,
                  style: TextStyles.caption,
                ),
                AutoSizeText(
                  'Airport data set by openflights.org',
                  minFontSize: 11.0,
                  maxLines: 1,
                  style: TextStyles.caption,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
