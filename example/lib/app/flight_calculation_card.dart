import 'package:flight_co2_calculator_flutter_example/app/constants/palette.dart';
import 'package:flight_co2_calculator_flutter_example/app/constants/text_styles.dart';
import 'package:flight_co2_calculator_flutter_example/blocs/flight_details_bloc.dart';
import 'package:flutter/material.dart';

class FlightCalculationCard extends StatelessWidget {
  FlightCalculationCard({this.flightCalculationData});
  final FlightData flightCalculationData;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Container(
        color: Palette.greenLandLight,
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: FlightCalculationDataItem(
                title: 'Distance',
                body: flightCalculationData.distanceFormatted,
              ),
            ),
            Expanded(
              child: FlightCalculationDataItem(
                title: 'Estimated CO2e',
                body: flightCalculationData.co2eFormatted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FlightCalculationDataItem extends StatelessWidget {
  FlightCalculationDataItem({this.title, this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyles.caption,
        ),
        Text(
          body,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
