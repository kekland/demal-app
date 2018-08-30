import 'dart:math';

import 'package:flutter/material.dart';

class PageRevealWidget extends StatelessWidget {
  final double revealPercent;
  final Widget child;
  final Offset clickPosition;
  final double revealPositionX;
  final double revealPositionY;
  PageRevealWidget({
    this.revealPercent,
    this.child,
    this.clickPosition,
    this.revealPositionX = 0.5,
    this.revealPositionY = 0.9,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: child,
      clipper: new CircleRevealClipper(revealPercent, clickPosition, revealPositionX, revealPositionY),
    );
  }
}

class CircleRevealClipper extends CustomClipper<Rect> {
  final double revealPercent;
  final Offset epicenter;
  final revealPositionX, revealPositionY;

  CircleRevealClipper(this.revealPercent, this.epicenter, this.revealPositionX, this.revealPositionY);

  @override
  Rect getClip(Size size) {
    Offset definedEpicenter;
    if (epicenter == null) {
      definedEpicenter = new Offset(size.width * revealPositionX, size.height * revealPositionY);
    } else {
      definedEpicenter = epicenter;
    }
    double height = size.height;
    double width = size.width;

    double epicHeight = definedEpicenter.dy;
    double leftoverHeight = height - epicHeight;

    double epicWidth = definedEpicenter.dx;
    double leftoverWidth = width - epicWidth;

    List<double> hyp = [
      pythagorasSquared(width, height),
      pythagorasSquared(width, leftoverHeight),
      pythagorasSquared(leftoverWidth, height),
      pythagorasSquared(leftoverWidth, leftoverHeight),
    ];
    double radius = 0.0;
    hyp.forEach((double hypotenuse) {
      if (hypotenuse > radius) {
        radius = hypotenuse;
      }
    });

    radius = sqrt(radius);
    radius *= revealPercent;
    final diameter = radius * 2;

    return new Rect.fromLTWH(definedEpicenter.dx - radius, definedEpicenter.dy - radius, diameter, diameter);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }

  double pythagorasSquared(double dx, double dy) {
    return pow(dx, 2) + pow(dy, 2);
  }
}