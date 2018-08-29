import 'package:dem_al/onboarding_page/onboarding_page.dart';
import 'package:dem_al/status_page/status_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  String defaultRoute = 'onboarding';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool onboardingPassed = prefs.getBool('onboarding_passed');
  if (onboardingPassed != null && onboardingPassed) {
    defaultRoute = 'status';
  }
  runApp(new MyApp(
    defaultRoute: defaultRoute,
  ));
}

class MyApp extends StatelessWidget {
  final String defaultRoute;

  const MyApp({Key key, this.defaultRoute}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    return new MaterialApp(
      title: 'DemAl',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: (defaultRoute == 'onboarding')? OnboardingPage() : StatusPage(),
      routes: {
        '/onboarding': (context) {
          return OnboardingPage();
        },
        '/status': (context) {
          return StatusPage();
        }
      },
    );
  }
}
