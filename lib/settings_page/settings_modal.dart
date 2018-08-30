import 'package:dem_al/demal_platform.dart';
import 'package:dem_al/settings_page/setting_card.dart';
import 'package:flutter/material.dart';

class SettingsModal extends StatefulWidget {
  @override
  _SettingsModalState createState() => _SettingsModalState();
}

class _SettingsModalState extends State<SettingsModal> {
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
            text: Text('HC-05',
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
            text: Text('+77006532708',
                style: TextStyle(fontSize: 16.0, color: Colors.white)),
            action: FlatButton(
                child: Text('Change'),
                textColor: Colors.white,
                onPressed: () {}),
          ),
          Row(
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
