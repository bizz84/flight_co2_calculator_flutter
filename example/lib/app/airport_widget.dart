import 'package:auto_size_text/auto_size_text.dart';
import 'package:flight_co2_calculator_flutter/airport.dart';
import 'package:flutter/material.dart';

class AirportWidget extends StatelessWidget {
  AirportWidget({this.iconData, this.title, this.airport, this.onPressed});
  /// icon data to use (normally Icons.flight_takeoff or Icons.flight_land)
  final IconData iconData;
  /// Title to show
  final Widget title;
  /// Airport to show
  final Airport airport;
  /// Callback that fires when the user taps on this widget
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    final airportDisplayName =
        airport != null ? '${airport.name} (${airport.iata})' : 'Select...';
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(iconData),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  title,
                  SizedBox(height: 4.0),
                  AutoSizeText(
                    airportDisplayName,
                    style: TextStyle(fontSize: 16.0),
                    minFontSize: 13.0,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Divider(height: 1.0, color: Colors.black87),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
