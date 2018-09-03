import 'dart:math';

import 'package:flutter/material.dart';

class GradientBackgroundWidget extends StatelessWidget {
  final double qualityPoints;
  final Animation<double> animation;
  final Widget child;
  GradientBackgroundWidget({this.qualityPoints, this.animation, this.child});
  LinearGradient createGradient() {
    return LinearGradient.lerp(
      LinearGradient(
        colors: getBackgroundColors(0.0),
        begin: AlignmentDirectional.topStart,
        end: AlignmentDirectional.bottomEnd,
      ),
      LinearGradient(
        colors: getBackgroundColors(100.0),
        begin: AlignmentDirectional.topStart,
        end: AlignmentDirectional.bottomEnd,
      ),
      sqrt(qualityPoints / 100.0),
    );
  }

  List<Color> getBackgroundColors(double points) {
    if (points > 75.0) {
      return [
        Color.lerp(Colors.green, Colors.lime, animation.value),
        Color.lerp(Colors.teal, Colors.lightGreen, animation.value),
      ];
    } else if (points > 50.0) {
      return [
        Color.lerp(Colors.lightGreen, Colors.orange, animation.value),
        Color.lerp(Colors.amber, Colors.lime, animation.value),
      ];
    } else if (points > 30.0) {
      return [
        Color.lerp(Colors.deepOrange, Colors.yellow, animation.value),
        Color.lerp(Colors.amber, Colors.orange, animation.value),
      ];
    } else {
      return [
        Color.lerp(Colors.deepOrange, Colors.orange, animation.value),
        Color.lerp(Colors.amber, Colors.red, animation.value),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: createGradient(),
      ),
      child: child,
    );
  }
}
