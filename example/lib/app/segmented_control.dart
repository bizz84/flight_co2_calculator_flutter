
import 'package:flight_co2_calculator_flutter_example/app/constants/palette.dart';
import 'package:flutter/cupertino.dart';

class SegmentedControl<T> extends StatelessWidget {
  SegmentedControl({this.header, this.value, this.children, this.onValueChanged});
  final Widget header;
  final T value;
  final Map<T, Widget> children;
  final ValueChanged<T> onValueChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: header,
        ),
        SizedBox(
          width: double.infinity,
          child: CupertinoSegmentedControl<T>(
            children: children,
            groupValue: value,
            selectedColor: Palette.blueSky,
            pressedColor: Palette.blueSkyLighter,
            onValueChanged: onValueChanged,
          ),
        ),
      ],
    );
  }
}