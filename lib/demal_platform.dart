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
    } on PlatformException catch (e) {
    }   
  }
  static Future<Null> stopService() async {
    try {
      await platform.invokeMethod('stopService');
    } on PlatformException catch (e) {
    }
  }
  static Future<Null> eventSinkAvailable() async {
    try {
      await platform.invokeMethod('eventSinkAvailable');
    } on PlatformException catch (e) {
    }
  }
}