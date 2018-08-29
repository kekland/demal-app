import 'package:flutter/material.dart';

class SliderPercentWidget extends StatelessWidget {
  final double percentage;
  SliderPercentWidget({this.percentage});
  @override
  Widget build(BuildContext context) {
    List<Widget> tickers = [];
    int tickerCount = 40;

    int bigTickerIndex =
        tickerCount - ((percentage * (tickerCount - 1)).round()) - 1;
    for (int i = 0; i < tickerCount; i++) {
      if (i == bigTickerIndex) {
        tickers.add(BigTicker());
      }
      else if (i == 0) {
        tickers.add(EndTicker(text: '100'));
      } else if (i == tickerCount - 1) {
        tickers.add(EndTicker(text: '0'));
      } else {
        tickers.add(Ticker());
      }
    }
    return Column(
      children: tickers,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}

class Ticker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        widthFactor: 1.0,
        child: Container(
          width: 8.0,
          height: 1.0,
          color: Colors.white.withOpacity(0.5),
        ),
      ),
    );
  }
}

class BigTicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        widthFactor: 1.0,
        child: Container(
          width: 16.0,
          height: 1.0,
          color: Colors.white,
        ),
      ),
    );
  }
}

class EndTicker extends StatelessWidget {
  final String text;
  EndTicker({this.text});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 16.0,
            height: 1.0,
            color: Colors.white.withOpacity(0.5),
          ),
          SizedBox(width: 8.0),
          Text(
            text,
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
