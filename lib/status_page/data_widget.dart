import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DataWidget extends StatelessWidget {
  final String description, value, iconAsset;
  final Brightness brightness;
  DataWidget({this.value, this.description, this.iconAsset, this.brightness});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 24.0,
          height: 24.0,
          child: SvgPicture.asset(
            iconAsset,
            color: (brightness == Brightness.light)
                ? Colors.white70
                : Colors.black54,
          ),
        ),
        Text(
          description,
          style: TextStyle(
            color: (brightness == Brightness.light)
                ? Colors.white70
                : Colors.black54,
          ),
        ),
        Text(value,
            style: TextStyle(
            color: (brightness == Brightness.light)
                ? Colors.white
                : Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}
