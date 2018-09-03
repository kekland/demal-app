import 'dart:async';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DemAlPlatform {
  static const platform = const MethodChannel('com.kekland.demal/device');
  static const stream = const EventChannel('com.kekland.demal/deviceStream');
  static Future<Null> launchService() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String deviceID = prefs.getString("device_id");
      await platform.invokeMethod('launchService', <String, dynamic>{
        'deviceId': deviceID,
      });
    } on PlatformException catch (e) {
    }   
  }

  static Future<bool> launchScan() async {
    try {
      String address = await platform.invokeMethod('listenForDevice');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(address);
      prefs.setString("device_id", address);
      return true;
    }
    on PlatformException catch(e) {
      return false;
    }
  }
  static Future<Null> stopScan() async {
    try {
      await platform.invokeMethod('stopListeningForDevice');
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