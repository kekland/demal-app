import 'package:dem_al/status_page/data_widget.dart';
import 'package:flutter/material.dart';

class BottomPanel extends StatefulWidget {
  final double scrollValue;

  const BottomPanel({Key key, this.scrollValue}) : super(key: key);

  @override
  _BottomPanelState createState() => _BottomPanelState();
}

class _BottomPanelState extends State<BottomPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(widget.scrollValue / 2.0),
      width: double.infinity,
      height: double.infinity,
      alignment: AlignmentDirectional.bottomCenter,
      child: Transform(
        alignment: AlignmentDirectional.bottomCenter,
        transform: new Matrix4.translationValues(
            0.0, 200.0 * (1.0 - widget.scrollValue), 0.0),
        child: Container(
          width: double.infinity,
          height: 200.0,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24.0, left: 8.0, right: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      gradient: LinearGradient(
                        colors: [
                          Colors.cyan,
                          Colors.blue,
                        ],
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                      ),
                    ),
                    child: DataWidget(
                      value: '0%',
                      description: 'Humidity',
                      iconAsset: 'assets/icons/water-percent.svg',
                      brightness: Brightness.light,
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.purple,
                    ),
                    child: DataWidget(
                      value: 'No data',
                      description: 'Gases',
                      iconAsset: 'assets/icons/periodic-table-co2.svg',
                      brightness: Brightness.light,
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.purple,
                    ),
                    child: DataWidget(
                      value: 'No data',
                      description: 'Dust',
                      iconAsset: 'assets/icons/weather-windy.svg',
                      brightness: Brightness.light,
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.purple,
                    ),
                    child: DataWidget(
                      value: 'No data',
                      description: 'Temperature',
                      iconAsset: 'assets/icons/temperature-celsius.svg',
                      brightness: Brightness.light,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
