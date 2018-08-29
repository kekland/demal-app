import 'package:flutter/material.dart';

class SettingCard extends StatelessWidget {
  final Widget icon;
  final Widget text;
  final Widget action;
  final Color color;

  const SettingCard({Key key, this.icon, this.text, this.action, this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      color: color,
      borderRadius: BorderRadius.circular(100.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 8.0, top: 8.0, bottom: 8.0),
        child: Row(
          children: [
            Padding(padding: const EdgeInsets.only(right: 8.0), child: icon),
            Expanded(child: text),
            action,
          ],
        ),
      ),
    );
  }
}
