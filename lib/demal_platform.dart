import 'dart:async';

import 'package:flutter/services.dart';

class DemAlPlatform {
  static const platform = const MethodChannel('com.kekland.demal/device');
  static Future<Null> launchService() async {
    try {
      await platform.invokeMethod('launchService');
      print('Success');
    } on PlatformException catch (e) {
      print('Failure: ${e.message}');
    }
  }
  static Future<Null> stopService() async {
    try {
      await platform.invokeMethod('stopService');
      print('Success');
    } on PlatformException catch (e) {
      print('Failure: ${e.message}');
    }
  }
}