import 'package:dem_al/status_page/respiration_animation/circle.dart';
import 'package:flutter/material.dart';

class RespirationCircleWidget extends StatefulWidget {
  final double opacity;
  final double minimum;
  RespirationCircleWidget({this.opacity, this.minimum = 0.0});

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
        AnimationController(vsync: this, lowerBound: widget.minimum, duration: Duration(seconds: 4));

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
        curve: Curves.decelerate,
        reverseCurve: Curves.decelerate);
    controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: animation.value,
      child: ScaleTransition(
        scale: animation,
        child: RotationTransition(
          turns: AlwaysStoppedAnimation(animation.value * 0.5),
          child: Stack(
            children: [
              Transform(
                transform: Matrix4.translationValues(
                    -35.0 * animation.value, -50.0 * animation.value, 0.0),
                child: SemiTransparentCircleWidget(
                    radius: 100.0, color: Colors.white.withOpacity(widget.opacity)),
              ),
              Transform(
                transform: Matrix4.translationValues(
                    35.0 * animation.value, -50.0 * animation.value, 0.0),
                child: SemiTransparentCircleWidget(
                    radius: 100.0, color: Colors.white.withOpacity(widget.opacity)),
              ),
              Transform(
                transform: Matrix4.translationValues(
                    -60.0 * animation.value, 0.0 * animation.value, 0.0),
                child: SemiTransparentCircleWidget(
                    radius: 100.0, color: Colors.white.withOpacity(widget.opacity)),
              ),
              Transform(
                transform: Matrix4.translationValues(
                    60.0 * animation.value, 0.0 * animation.value, 0.0),
                child: SemiTransparentCircleWidget(
                    radius: 100.0, color: Colors.white.withOpacity(widget.opacity)),
              ),
              Transform(
                transform: Matrix4.translationValues(
                    -35.0 * animation.value, 50.0 * animation.value, 0.0),
                child: SemiTransparentCircleWidget(
                    radius: 100.0, color: Colors.white.withOpacity(widget.opacity)),
              ),
              Transform(
                transform: Matrix4.translationValues(
                    35.0 * animation.value, 50.0 * animation.value, 0.0),
                child: SemiTransparentCircleWidget(
                    radius: 100.0, color: Colors.white.withOpacity(widget.opacity)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
