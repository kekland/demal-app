import 'package:dem_al/status_page/wave_background/wave_clipper.dart';
import 'package:flutter/material.dart';

class WaveBackgroundWidget extends StatefulWidget {
  final double height;
  final double amplitude;
  final double xOffset;
  final Duration animationDuration;
  WaveBackgroundWidget(
      {this.height, this.amplitude, this.animationDuration, this.xOffset});

  @override
  WaveBackgroundWidgetState createState() {
    return new WaveBackgroundWidgetState();
  }
}

class WaveBackgroundWidgetState extends State<WaveBackgroundWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  initState() {
    super.initState();

    controller = new AnimationController(
        vsync: this, duration: widget.animationDuration);

    controller.addListener(() {
      setState(() {});
    });

    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Container(
        width: double.infinity,
        height: widget.height,
        color: Colors.white10,
      ),
      clipper: WaveClipper(controller.value, widget.amplitude, widget.xOffset),
    );
  }
}
