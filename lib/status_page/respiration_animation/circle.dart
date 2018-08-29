import 'package:flutter/material.dart';

class SemiTransparentCircleWidget extends StatelessWidget {
  final double radius;
  final Color color;

  const SemiTransparentCircleWidget({Key key, this.radius, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        backgroundBlendMode: BlendMode.screen,
        color: color,
      ),
    );
  }
}