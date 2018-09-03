import 'package:dem_al/fluro/application.dart';
import 'package:dem_al/fluro/handlers.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  String defaultRoute = '/';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool onboardingPassed = prefs.getBool('onboarding_passed');
  if (onboardingPassed != null && onboardingPassed) {
    defaultRoute = '/';
  }

  final router = new Router();
  Routes.configureRoutes(router);
  Application.router = router;

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

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return new MaterialApp(
      title: 'DemAl',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: Application.router.generator,
      initialRoute: '/',
    );
  }
}
