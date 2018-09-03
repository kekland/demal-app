import 'dart:async';

import 'package:dem_al/bottom_sheet_fix.dart';
import 'package:dem_al/demal_platform.dart';
import 'package:dem_al/settings_page/settings_modal.dart';
import 'package:dem_al/status_page/air_quality_widget.dart';
import 'package:dem_al/status_page/app_title.dart';
import 'package:dem_al/status_page/colored_background.dart';
import 'package:dem_al/status_page/data_widget.dart';
import 'package:dem_al/status_page/respiration_animation/respiration_circle.dart';
import 'package:dem_al/status_page/slider_percent.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

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
    double humidityQuality;
    double gasQuality = 0.0;
    if (gasLevel < 0.2) {
      gasQuality = 1.0;
    } else if (gasLevel < 0.5) {
      gasQuality = 1.0 - (gasLevel - 0.5).abs() / 0.3;
    } else {
      gasQuality = 0.0;
    }

    if (humidityLevel > 20.0 && humidityLevel <= 40.0) {
      humidityQuality = 1.0;
    } else if (humidityLevel <= 20.0) {
      humidityQuality = humidityLevel / 20.0;
    } else if (humidityLevel > 40.0) {
      humidityQuality = 1.0 - ((humidityLevel - 40.0) / 60.0);
    }

    return (humidityQuality * 0.5 + gasQuality * 0.5) * 100;
  }

  String getGasLevel() {
    if (gasLevel < 0.25) {
      return 'Good';
    } else if (gasLevel < 0.5) {
      return 'Mediocre';
    } else {
      return 'Bad';
    }
  }

  setOnboardingViewed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('onboarding_passed', true);
  }

  StreamSubscription subscription;
  initState() {
    DemAlPlatform.launchService();
    subscription =
        DemAlPlatform.stream.receiveBroadcastStream().listen(onDataReceive);
    DemAlPlatform.eventSinkAvailable();

    setOnboardingViewed();

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

  onDataReceive(data) {
    setState(() {
      gasLevel = data['airQuality'];
      humidityLevel = data['humidity'].toDouble();
    });
  }

  openSettings(BuildContext context) {
    showModalBottomSheetFixed(
      context: context,
      builder: (context) {
        return SettingsModal();
      },
      dismissOnTap: false,
      resizeToAvoidBottomPadding: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackgroundWidget(
        animation: animation,
        qualityPoints: calculatePoints(),
        child: SafeArea(
          child: Transform(
            transform: new Matrix4.translationValues(
                0.0, -30.0 * (1.0 - startAnimation.value), 0.0),
            child: Opacity(
              opacity: startAnimation.value,
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
                      onPressed: () {
                        openSettings(context);
                      },
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
                    alignment: AlignmentDirectional(0.0, -0.18),
                    child: RespirationCircleWidget(
                      opacity: 0.07,
                      minimum: 0.25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    startAnimationController.dispose();
    subscription.cancel();
    super.dispose();
  }
}
