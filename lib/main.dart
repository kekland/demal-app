import 'package:dem_al/onboarding_page/onboarding_page.dart';
import 'package:dem_al/status_page/status_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
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
      home: new OnboardingPage(),
    );
  }
}