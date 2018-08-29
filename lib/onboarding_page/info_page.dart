import 'package:dem_al/status_page/respiration_animation/respiration_circle.dart';
import 'package:flutter/material.dart';

class InfoPageData {
  String title;
  String description;
  Widget icon;
  Widget action;

  InfoPageData({this.title, this.description, this.icon, this.action});
}

class InfoPage extends StatelessWidget {
  final InfoPageData data;

  const InfoPage({Key key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Stack(
        children: [
          Align(
              alignment: AlignmentDirectional(0.0, -0.5),
              child: RespirationCircleWidget(
                opacity: 0.15,
                minimum: 0.5,
              )),
          Align(alignment: AlignmentDirectional(0.0, -0.41), child: data.icon),
          Align(
            alignment: AlignmentDirectional(0.0, 0.65),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Futura',
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  data.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 32.0),
                data.action,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
