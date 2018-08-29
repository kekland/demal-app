import 'package:dem_al/status_page/respiration_animation/circle.dart';
import 'package:flutter/material.dart';

class RespirationCircleWidget extends StatefulWidget {
  final double radius;
  RespirationCircleWidget({this.radius});

  @override
  _RespirationCircleWidgetState createState() =>
      _RespirationCircleWidgetState();
}

class _RespirationCircleWidgetState extends State<RespirationCircleWidget>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 4));

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.addListener(() {
      setState(() {});
    });

    animation = CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeInOut);
    controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: AlwaysStoppedAnimation(0.15 + (0.85 * animation.value)),
      child: RotationTransition(
        turns: AlwaysStoppedAnimation(animation.value * 0.5),
        child: Stack(
          children: [
            Transform(
              transform: Matrix4.translationValues(
                  -35.0 * animation.value, -50.0 * animation.value, 0.0),
              child: SemiTransparentCircleWidget(radius: 62.5, color: Colors.white),
            ),
            Transform(
              transform: Matrix4.translationValues(
                  35.0 * animation.value, -50.0 * animation.value, 0.0),
              child: SemiTransparentCircleWidget(radius: 62.5, color: Colors.white),
            ),
            Transform(
              transform: Matrix4.translationValues(
                  -60.0 * animation.value, 0.0 * animation.value, 0.0),
              child: SemiTransparentCircleWidget(radius: 62.5, color: Colors.white),
            ),
            Transform(
              transform: Matrix4.translationValues(
                  60.0 * animation.value, 0.0 * animation.value, 0.0),
              child: SemiTransparentCircleWidget(radius: 62.5, color: Colors.white),
            ),
            Transform(
              transform: Matrix4.translationValues(
                  -35.0 * animation.value, 50.0 * animation.value, 0.0),
              child: SemiTransparentCircleWidget(radius: 62.5, color: Colors.white),
            ),
            Transform(
              transform: Matrix4.translationValues(
                  35.0 * animation.value, 50.0 * animation.value, 0.0),
              child: SemiTransparentCircleWidget(radius: 62.5, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
