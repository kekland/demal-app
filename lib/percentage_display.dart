import 'package:flutter/material.dart';

class PercentageDisplayWidget extends StatelessWidget {
  final int value;
  final double animationValue;
  final String maximumValue;
  final String description;
  PercentageDisplayWidget({this.value, this.animationValue, this.description, this.maximumValue});

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.body1.copyWith(
                fontWeight: FontWeight.w500,
                    color: Colors.white,
                fontSize: 40.0,
              ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              maximumValue,
              style: Theme.of(context).textTheme.caption.copyWith(
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
            ),
            Text(
              description,
              style: Theme.of(context).textTheme.subhead.copyWith(
                    fontSize: 18.0,
                    color: Colors.white70
                  ),
            ),
          ],
        ),
      ],
    );
  }
}