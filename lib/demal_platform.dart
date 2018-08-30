import 'dart:async';

import 'package:flutter/services.dart';

class DemAlPlatform {
  static const platform = const MethodChannel('com.kekland.demal/device');
  static const stream = const EventChannel('com.kekland.demal/deviceStream');
  static Future<Null> launchService() async {
    try {
      await platform.invokeMethod('launchService', <String, dynamic>{
        'deviceId': '10:22:33:44:55:66',
      });
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
  static Future<Null> eventSinkAvailable() async {
    try {
      await platform.invokeMethod('eventSinkAvailable');
      print('Success');
    } on PlatformException catch (e) {
      print('Failure: ${e.message}');
    }
  }
}