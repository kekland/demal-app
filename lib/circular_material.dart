import 'package:flutter/material.dart';

class CircleMaterialWidget extends StatelessWidget {
  final double radius;
  final Widget child;
  final Color color;
  final Animation<double> revealAnimation;
  CircleMaterialWidget({this.radius, this.child, this.revealAnimation, this.color});
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      alignment: Alignment.center,
      scale: revealAnimation,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        elevation: 16.0,
        child: SizedBox(
          width: radius * 2,
          height: radius * 2,
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
