import 'package:dem_al/circular_material.dart';
import 'package:dem_al/linear_gradient_tween.dart';
import 'package:dem_al/percentage_display.dart';
import 'package:dem_al/status_page/air_quality_widget.dart';
import 'package:dem_al/status_page/app_title.dart';
import 'package:dem_al/status_page/colored_background.dart';
import 'package:dem_al/status_page/data_widget.dart';
import 'package:dem_al/status_page/respiration_animation/respiration_circle.dart';
import 'package:dem_al/status_page/slider_percent.dart';
import 'package:dem_al/status_page/wave_background/wave_background.dart';
import 'package:dem_al/tab_widget.dart';
import 'package:dem_al/title_text_widget.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_svg/flutter_svg.dart';

class StatusPage extends StatefulWidget {
  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  AnimationController startAnimationController;
  Animation<double> startAnimation;

  double humidityLevel = 50.0, gasLevel = 500.0, dustLevel = -1.0;

  double calculatePoints() {
    return animation.value * 100.0;
    double humidityQuality = (humidityLevel - 50.0).abs() / 50.0;
    double gasQuality = 0.0;
    if (gasLevel < 200.0) {
      gasQuality = 1.0;
    } else if (gasLevel < 500.0) {
      gasQuality = 1.0 - (gasLevel - 200.0).abs() / 300.0;
    } else {
      gasQuality = 0.0;
    }

    if (humidityLevel > 20.0 && humidityLevel < 40.0) {
      humidityQuality = 1.0;
    } else if (humidityLevel < 20.0) {
      humidityQuality = humidityLevel / 20.0;
    } else if (humidityLevel > 40.0) {
      humidityQuality = 1.0 - ((humidityLevel - 40.0) / 60.0);
    }

    return (humidityQuality * 0.5 + gasQuality * 0.5) * 100;
  }

  String getGasLevel() {
    if (gasLevel < 200.0) {
      return 'Good';
    } else if (gasLevel < 500.0) {
      return 'Fine';
    } else {
      return 'Bad';
    }
  }

  initState() {
    super.initState();
    controller =
        new AnimationController(vsync: this, duration: Duration(seconds: 3));
    animation = CurvedAnimation(
        parent: controller, curve: Curves.linear, reverseCurve: Curves.linear);

    startAnimationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 1));
    startAnimation = new CurvedAnimation(
        parent: startAnimationController, curve: Curves.easeInOut);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    animation.addListener(() {
      setState(() {});
    });
    startAnimation.addListener(() {
      setState(() {});
    });

    controller.forward();
    startAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackgroundWidget(
        animation: animation,
        qualityPoints: calculatePoints(),
        child: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional.topCenter,
                child: AppTitleWidget(),
              ),
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: IconButton(
                  icon: Icon(Icons.settings),
                  color: Colors.white,
                  onPressed: () {},
                ),
              ),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: SliderPercentWidget(
                    percentage: calculatePoints() / 100.0,
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, -0.15),
                child: AirQualityWidget(
                  qualityLevel: calculatePoints(),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 24.0, left: 8.0, right: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      DataWidget(
                        value: '${humidityLevel.round()}%',
                        description: 'Humidity',
                        iconAsset: 'assets/icons/water-percent.svg',
                      ),
                      DataWidget(
                        value: getGasLevel(),
                        description: 'Gases',
                        iconAsset: 'assets/icons/periodic-table-co2.svg',
                      ),
                      DataWidget(
                        value: 'No data',
                        description: 'Dust',
                        iconAsset: 'assets/icons/weather-windy.svg',
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 0.15),
                child: RespirationCircleWidget(radius: 128.0),
              ),
              /*
              Align(
                alignment: AlignmentDirectional.bottomStart,
                child: WaveBackgroundWidget(
                  height: 200.0,
                  amplitude: 30.0,
                  animationDuration: Duration(milliseconds: 3287),
                  xOffset: 10.0,
                ),
              ),
              Align(
                alignment: AlignmentDirectional.bottomStart,
                child: WaveBackgroundWidget(
                  height: 190.0,
                  amplitude: 25.0,
                  animationDuration: Duration(milliseconds: 2119),
                  xOffset: 0.0,
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
