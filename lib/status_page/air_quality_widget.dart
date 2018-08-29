import 'package:flutter/material.dart';

class AirQualityWidget extends StatelessWidget {
  final double qualityLevel;
  AirQualityWidget({this.qualityLevel});
  
  String getAirQualityLevel() {
    if(qualityLevel > 75.0) {
      return 'Healthy';
    }
    else if(qualityLevel > 50.0) {
      return 'Fine';
    }
    else if(qualityLevel > 30.0) {
      return 'Bad';
    }
    else {
      return 'Dangerous';
    }
  }

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
          getAirQualityLevel(),
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
              qualityLevel.round().toString(),
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
