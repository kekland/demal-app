import 'dart:async';

import 'package:dem_al/fluro/application.dart';
import 'package:dem_al/linear_gradient_tween.dart';
import 'package:dem_al/onboarding_page/info_page.dart';
import 'package:dem_al/onboarding_page/ticker.dart';
import 'package:dem_al/status_page/respiration_animation/respiration_circle.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:contact_picker/contact_picker.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  AnimationController switchController;
  Animation<LinearGradient> switchAnimation;
  Animation<double> switchTransformAnimation;
  int selected = 0;
  initState() {
    super.initState();
    controller =
        new AnimationController(vsync: this, duration: Duration(seconds: 3));
    animation = CurvedAnimation(
        parent: controller, curve: Curves.linear, reverseCurve: Curves.linear);
    switchController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 500));
    switchAnimation = AlwaysStoppedAnimation(getGradient(0));
    switchTransformAnimation =
        CurvedAnimation(parent: switchController, curve: Curves.easeInOut);

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.addListener(() {
      setState(() {});
    });

    switchController.addListener(() {
      setState(() {});
    });

    controller.forward();
    switchController.forward();
  }

  static const bool MOCK_BLUETOOTH_DEVICE = true;
  var scanSubscription;
  final ContactPicker contactPicker = new ContactPicker();
  nextPage(BuildContext context) {
    setState(() {
      if (selected == 3) {
        Application.router.navigateTo(
          context,
          '/',
          transition: TransitionType.custom,
          replace: true,
          transitionBuilder: (context, anim1, anim2, widget) {},
          transitionDuration: Duration(seconds: 1),
        );
      } else {
        switchAnimation = LinearGradientTween(
          begin: getGradient(selected),
          end: getGradient(selected + 1),
        ).animate(switchController);

        switchController.forward(from: 0.0);
        selected++;

        if (selected == 1) {
          FlutterBlue blue = FlutterBlue.instance;
          if (!MOCK_BLUETOOTH_DEVICE) {
            scanSubscription =
                blue.scan(scanMode: ScanMode.balanced).listen((result) async {
              if (result.device.name == 'DemAl') {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('device_id', result.device.id.id);
                nextPage(context);
              }
            });
          } else {
            new Future.delayed(Duration(seconds: 2), () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('device_id', '10:11:12:13:14:15');
              nextPage(context);
            });
          }
        } else if (selected == 2) {
          if (!MOCK_BLUETOOTH_DEVICE) {
            scanSubscription.cancel();
          }
        }
      }
    });
  }

  selectContact(BuildContext context) async {
    Contact contact = await contactPicker.selectContact();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phone_number', contact.phoneNumber.number);
    prefs.setString('phone_name', contact.fullName);
    nextPage(context);
  }

  @override
  dispose() {
    controller.dispose();
    switchController.dispose();
    scanSubscription.cancel();
    super.dispose();
  }

  LinearGradient getGradient(int index) {
    if (index == 0) {
      return LinearGradient(
        colors: [
          Color.lerp(Colors.green, Colors.teal, animation.value),
          Color.lerp(Colors.teal, Colors.green, animation.value),
        ],
        begin: AlignmentDirectional.topStart,
        end: AlignmentDirectional.bottomEnd,
      );
    } else if (index == 1) {
      return LinearGradient(
        colors: [
          Color.lerp(Colors.blue, Colors.teal, animation.value),
          Color.lerp(Colors.lightBlue, Colors.indigo, animation.value),
        ],
        begin: AlignmentDirectional.topStart,
        end: AlignmentDirectional.bottomEnd,
      );
    } else if (index == 2) {
      return LinearGradient(
        colors: [
          Color.lerp(Colors.indigo, Colors.red, animation.value),
          Color.lerp(Colors.pink, Colors.deepPurple, animation.value),
        ],
        begin: AlignmentDirectional.topStart,
        end: AlignmentDirectional.bottomEnd,
      );
    } else if (index == 3) {
      return LinearGradient(
        colors: [
          Color.lerp(Colors.blue, Colors.cyan, animation.value),
          Color.lerp(Colors.lightBlue, Colors.teal, animation.value),
        ],
        begin: AlignmentDirectional.topStart,
        end: AlignmentDirectional.bottomEnd,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List pages = [
      InfoPageData(
        title: 'Welcome!',
        description:
            'Welcome to DemAl! This application will help you in case of asthma attack.',
        icon: Container(),
        action: FloatingActionButton.extended(
          label: Text('Next'),
          icon: Icon(Icons.chevron_right),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          onPressed: () => nextPage(context),
        ),
      ),
      InfoPageData(
        title: 'Connect to your device',
        description:
            'Turn on your DemAl device and wait for a moment. Make sure that your device is paired with your phone.',
        icon: Icon(
          Icons.bluetooth,
          color: Colors.white,
          size: 64.0,
        ),
        action: Material(
          borderRadius: BorderRadius.circular(100.0),
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16.0),
                Text(
                  'Looking for your device',
                  style: TextStyle(
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      InfoPageData(
        title: 'Add your guardian\'s phone number',
        description:
            'With this feature you will be able to call your parent or guardian immediately in case of emergency',
        icon: Icon(
          Icons.phone,
          color: Colors.white,
          size: 64.0,
        ),
        action: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton.extended(
              label: Text('Select number'),
              icon: Icon(Icons.chevron_right),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              onPressed: () => selectContact(context),
            ),
            FloatingActionButton.extended(
              label: Text('Cancel'),
              icon: Icon(Icons.close),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              onPressed: () => nextPage(context),
            ),
          ],
        ),
      ),
      InfoPageData(
        title: 'All set!',
        description: 'You are now ready to use DemAl!',
        icon: Icon(
          Icons.check,
          color: Colors.white,
          size: 64.0,
        ),
        action: FloatingActionButton.extended(
          label: Text('Let\'s go!'),
          icon: Icon(Icons.chevron_right),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          onPressed: () => nextPage(context),
        ),
      ),
    ];
    InfoPageData emptyPage = InfoPageData(
        title: '', action: Container(), description: '', icon: Container());
    InfoPageData prevPageDisplay =
        (selected - 1 == -1) ? emptyPage : pages[selected - 1];
    InfoPageData currentPageDisplay = pages[selected];
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: (!switchAnimation.isCompleted)
              ? switchAnimation.value
              : getGradient(selected),
        ),
        child: Stack(
          children: <Widget>[
            Align(
                alignment: AlignmentDirectional(0.0, -0.46),
                child: RespirationCircleWidget(
                  opacity: 0.15,
                  minimum: 0.5,
                )),
            Transform(
              transform: Matrix4.translationValues(
                  -MediaQuery.of(context).size.width *
                      switchTransformAnimation.value,
                  0.0,
                  0.0),
              child: Opacity(
                opacity: 1.0 - switchTransformAnimation.value,
                child: InfoPage(
                  data: prevPageDisplay,
                  switchAnimation: (1.0 - switchTransformAnimation.value * 8.0)
                      .clamp(0.0, 1.0),
                ),
              ),
            ),
            Transform(
              transform: Matrix4.translationValues(
                  MediaQuery.of(context).size.width *
                      (1.0 - switchTransformAnimation.value),
                  0.0,
                  0.0),
              child: Opacity(
                opacity: switchTransformAnimation.value,
                child: InfoPage(
                  data: currentPageDisplay,
                  switchAnimation:
                      (switchTransformAnimation.value * 8.0).clamp(0.0, 1.0),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0.0, 0.9),
              child: BottomTicker(
                count: pages.length,
                selected: selected,
                width: 100.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
