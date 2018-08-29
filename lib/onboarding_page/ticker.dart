import 'package:flutter/material.dart';

class BottomTicker extends StatelessWidget {
  final int count;
  final int selected;
  final double width;
  const BottomTicker({Key key, this.count, this.selected, this.width})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Widget> tickers = [];
    for (int i = 0; i < count; i++) {
      if (i == selected) {
        tickers.add(
          Container(
            width: 12.0,
            height: 12.0,
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
        );
      } else {
        tickers.add(
          Container(
            width: 12.0,
            height: 12.0,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
        );
      }
    }
    return SizedBox(
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: tickers,
      ),
    );
  }
}
