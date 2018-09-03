import 'package:dem_al/demal_platform.dart';
import 'package:dem_al/settings_page/setting_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModal extends StatefulWidget {
  @override
  _SettingsModalState createState() => _SettingsModalState();
}

class _SettingsModalState extends State<SettingsModal> {
  @override
  initState() {
    super.initState();
    getPhoneNumber();
  }
  String phoneName = '', deviceName = '';
  getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _phoneName = prefs.getString('phone_name');
    String _deviceName = prefs.getString('device_name');

    setState(() {
          phoneName = _phoneName;
          deviceName = _deviceName;
        });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.w500,
              fontFamily: 'Futura',
            ),
          ),
          SizedBox(height: 16.0),
          SettingCard(
            color: Colors.indigo,
            icon: Icon(Icons.bluetooth, color: Colors.white70),
            text: Text(deviceName,
                style: TextStyle(fontSize: 16.0, color: Colors.white)),
            action: FlatButton(
                child: Text('Change'),
                textColor: Colors.white,
                onPressed: () {}),
          ),
          SizedBox(height: 8.0),
          SettingCard(
            color: Colors.pink,
            icon: Icon(Icons.phone, color: Colors.white70),
            text: Text(phoneName,
                style: TextStyle(fontSize: 16.0, color: Colors.white)),
            action: FlatButton(
                child: Text('Change'),
                textColor: Colors.white,
                onPressed: () {}),
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton.extended(
                icon: Icon(Icons.play_arrow),
                label: Text('Start service'),
                onPressed: DemAlPlatform.launchService,
              ),
              FloatingActionButton.extended(
                icon: Icon(Icons.stop),
                label: Text('Stop service'),
                onPressed: DemAlPlatform.stopService,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
