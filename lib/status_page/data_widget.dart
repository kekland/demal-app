import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DataWidget extends StatelessWidget {
  final String description, value, iconAsset;
  DataWidget({this.value, this.description, this.iconAsset});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24.0,
            height: 24.0,
            child: SvgPicture.asset(
              iconAsset,
              color: Colors.white70,
            ),
          ),
          Text(description, style: TextStyle(color: Colors.white70)),
          Text(value,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
