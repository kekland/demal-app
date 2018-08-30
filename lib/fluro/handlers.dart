import 'package:dem_al/onboarding_page/onboarding_page.dart';
import 'package:dem_al/status_page/status_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Routes {
  static String root = '/';
  static String status = '/status';

  static var statusHandler = new Handler(
    type: HandlerType.route,
    handlerFunc: (context, args) {
      return StatusPage();
    },
  );

  static var onboardingHandler = new Handler(
    type: HandlerType.route,
    handlerFunc: (context, args) {
      return OnboardingPage();
    }
  );

  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("Route was not found :/");
    });
    router.define(root, handler: onboardingHandler);
    router.define(status, handler: statusHandler);
  }
}
