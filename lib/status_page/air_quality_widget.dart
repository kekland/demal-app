import 'package:flutter/material.dart';

class AirQualityWidget extends StatelessWidget {
  final double qualityLevel;
  final String qualityString;
  AirQualityWidget({this.qualityLevel, this.qualityString});
  

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Air quality',
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        Text(
          qualityString,
          style: TextStyle(
            color: Colors.white,
            fontSize: 56.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              (qualityLevel * 100.0).round().toString(),
              style: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Points',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                Text(
                  '/100',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
