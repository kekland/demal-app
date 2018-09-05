import 'dart:async';

import 'package:dem_al/bottom_sheet_fix.dart';
import 'package:dem_al/demal_platform.dart';
import 'package:dem_al/settings_page/settings_modal.dart';
import 'package:dem_al/status_page/air_data.dart';
import 'package:dem_al/status_page/air_quality_widget.dart';
import 'package:dem_al/status_page/app_title.dart';
import 'package:dem_al/status_page/bottom_panel.dart';
import 'package:dem_al/status_page/bottom_panel_gestures.dart';
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
  AnimatedPageDragger dragger;
  bool isOpen = false;
  double bottomPanelSlideValue = 0.0;

  AirData airData = AirData.zero();

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
        new AnimationController(vsync: this, duration: Duration(seconds: 2));
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

    slideUpdateStream = new StreamController<SlideUpdate>();

    slideUpdateStream.stream.listen(onSlideUpdate);
  }

  onSlideUpdate(SlideUpdate event) {
    print(
        "Slide event: ${event.slidePercent}, ${event.slideDirection.toString()}, isUp: ${isOpen} ");
    setState(() {
      if (event.updateType == UpdateType.dragging) {
        slideDirection = event.slideDirection;
        slidePercent = event.slidePercent;

        if (slideDirection == SlideDirection.slideUp) {
          bottomPanelSlideValue = slidePercent;
        } else if (slideDirection == SlideDirection.slideDown) {
          bottomPanelSlideValue = 1.0 - slidePercent;
        } else {
          bottomPanelSlideValue = (isOpen) ? 1.0 : 0.0;
        }
      } else if (event.updateType == UpdateType.doneDragging) {
        if (event.forceAnimate) {
          dragger = new AnimatedPageDragger(
            slideDirection: event.slideDirection,
            slidePercent: event.slidePercent,
            transitionGoal: TransitionGoal.open,
            slideUpdateStream: slideUpdateStream,
            vsync: this,
          );
          isOpen = false;
          dragger.run();
        } else if (slidePercent > 0.5 &&
            slideDirection != SlideDirection.none) {
          dragger = new AnimatedPageDragger(
            slideDirection: slideDirection,
            slidePercent: slidePercent,
            transitionGoal: TransitionGoal.open,
            slideUpdateStream: slideUpdateStream,
            vsync: this,
          );
          isOpen = slideDirection == SlideDirection.slideUp;
          dragger.run();
        } else if (slidePercent <= 0.5 &&
            slideDirection != SlideDirection.none) {
          dragger = new AnimatedPageDragger(
            slideDirection: slideDirection,
            slidePercent: slidePercent,
            transitionGoal: TransitionGoal.close,
            slideUpdateStream: slideUpdateStream,
            vsync: this,
          );
          isOpen = slideDirection != SlideDirection.slideUp;
          dragger.run();
        }
      } else if (event.updateType == UpdateType.animating) {
        slideDirection = event.slideDirection;
        slidePercent = event.slidePercent;
        if (slideDirection == SlideDirection.slideUp) {
          bottomPanelSlideValue = slidePercent;
        } else if (slideDirection == SlideDirection.slideDown) {
          bottomPanelSlideValue = 1.0 - slidePercent;
        } else {
          bottomPanelSlideValue = 0.0;
        }
      } else if (event.updateType == UpdateType.doneAnimating) {
        slideDirection = SlideDirection.none;
        slidePercent = 0.0;
        dragger.dispose();
      }
    });
  }

  onDataReceive(data) {
    setState(() {
      airData = new AirData.fromMap(data);
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

  SlideDirection slideDirection = SlideDirection.none;
  double slidePercent = 0.0;
  StreamController<SlideUpdate> slideUpdateStream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackgroundWidget(
        animation: animation,
        qualityPoints: airData.overallQuality,
        child: Stack(
          children: <Widget>[
            SafeArea(
              child: Transform(
                transform: new Matrix4.translationValues(
                    0.0, 60.0 * (1.0 - startAnimation.value), 0.0),
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
                            percentage: airData.overallQuality,
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, -0.15),
                        child: AirQualityWidget(
                          qualityLevel: airData.overallQuality,
                          qualityString: airData.overallQualityString,
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
                              Expanded(
                                child: DataWidget(
                                  value:
                                      '${(airData.humidityNormalized * 100.0).round()}%',
                                  description: 'Humidity',
                                  iconAsset: 'assets/icons/water-percent.svg',
                                  brightness: Brightness.light,
                                ),
                              ),
                              Expanded(
                                child: DataWidget(
                                  value: airData.gasQualityString,
                                  description: 'Gases',
                                  iconAsset:
                                      'assets/icons/periodic-table-co2.svg',
                                  brightness: Brightness.light,
                                ),
                              ),
                              Expanded(
                                child: DataWidget(
                                  value: 'No data',
                                  description: 'Dust',
                                  iconAsset: 'assets/icons/weather-windy.svg',
                                  brightness: Brightness.light,
                                ),
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
            BottomPanel(
              scrollValue: bottomPanelSlideValue,
            ),
            BottomPanelGestureDetectorWidget(
              slideUpdateStream: slideUpdateStream,
              canSlideDown: isOpen,
              canSlideUp: !isOpen,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    startAnimationController.dispose();
    subscription.cancel();
    slideUpdateStream.close();
    super.dispose();
  }
}
