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
        AnimationController(vsync: this, duration: Duration(seconds: 2));
      
    controller.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        controller.duration = Duration(seconds: 3);
        controller.reverse();
      }
      else if(status == AnimationStatus.dismissed) {
        controller.duration = Duration(seconds: 2);
        controller.forward();
      }
    });
    
    controller.addListener(() {
      setState(() {});
    });

    animation = CurvedAnimation(parent: controller, curve: Curves.decelerate, reverseCurve: Curves.decelerate);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: Container(
        width: widget.radius * 2.0,
        height: widget.radius * 2.0,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}
