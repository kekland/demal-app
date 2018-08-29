import 'package:flutter/material.dart';

class TitleTextWidget extends StatelessWidget {
  final Text title;
  final Text text;
  TitleTextWidget({this.title, this.text});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        title,
        text,
      ],
    );
  }
}
