import 'package:flutter/material.dart';

class AppTitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Text(
        'DemAl',
        style: Theme.of(context).textTheme.title.copyWith(
              color: Colors.white,
            ),
      ),
    );
  }
}
