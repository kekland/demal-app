import 'dart:math';

import 'package:flutter/material.dart';

var deg2rad = 0.0174533;
class WaveClipper extends CustomClipper<Path> {
  final double animation;
  final double amplitude;
  final double xOffset;

  WaveClipper(this.animation, this.amplitude, this.xOffset);

  @override
  Path getClip(Size size) {
    Path path = new Path();

    List<Offset> points = [];
    for(int i = -2; i <= size.width.toInt() + 2; i++) {
      double x = i.toDouble();
      double sineValue = sin((animation * 2 * 360 - i + xOffset) % 360 * deg2rad);

      points.add(new Offset(x, sineValue * amplitude + amplitude));
    }


    path.addPolygon(points, false);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) =>
      animation != oldClipper.animation;
}