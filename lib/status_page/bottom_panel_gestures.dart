import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

class BottomPanelGestureDetectorWidget extends StatefulWidget {
  final StreamController<SlideUpdate> slideUpdateStream;
  final bool canSlideUp, canSlideDown;

  const BottomPanelGestureDetectorWidget({Key key, this.slideUpdateStream, this.canSlideUp, this.canSlideDown}) : super(key: key);

  @override
  _BottomPanelGestureDetectorWidgetState createState() => _BottomPanelGestureDetectorWidgetState();
}

class _BottomPanelGestureDetectorWidgetState extends State<BottomPanelGestureDetectorWidget> {
  Offset start;
  SlideDirection direction;
  double slidePercent;
  double paneHeight = 200.0;
  onDragStart(DragStartDetails details) {
    start = details.globalPosition;
  }

  onDragUpdate(DragUpdateDetails details) {
    if(start != null) {
      double delta = start.dy - details.globalPosition.dy;
      print(delta);

      if(delta > 0.0 && widget.canSlideUp) {
        direction = SlideDirection.slideUp;
      }
      else if(delta < 0.0 && widget.canSlideDown) {
        direction = SlideDirection.slideDown;
      }
      else {
        direction = SlideDirection.none;
      }

      if(direction != SlideDirection.none) {
        slidePercent = (delta / paneHeight).abs().clamp(0.0, 1.0);
      }
      else {
        slidePercent = 0.0;
      }

      widget.slideUpdateStream.add(SlideUpdate(UpdateType.dragging, direction, slidePercent, false));
    }
  }

  onDragEnd(DragEndDetails details) {
    widget.slideUpdateStream.add(new SlideUpdate(UpdateType.doneDragging, SlideDirection.none, 0.0, false));
    start = null;
  }

  onTap(TapUpDetails details, BuildContext context) {
    if(start != null) {return;}
    print(details.globalPosition.toString());
    double height = MediaQuery.of(context).size.height;
    double tapFromBottom = height - details.globalPosition.dy;

    if(tapFromBottom > 200.0 && widget.canSlideDown) {
      widget.slideUpdateStream.add(new SlideUpdate(UpdateType.doneDragging, SlideDirection.slideDown, 0.0, true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: onDragStart,
      onVerticalDragUpdate: onDragUpdate,
      onVerticalDragEnd: onDragEnd,
      onTapUp: (data) => onTap(data, context),
    );
  }
}

enum SlideDirection {
  slideUp,
  slideDown,
  none,
}

enum UpdateType {
  dragging,
  doneDragging,
  animating,
  doneAnimating,
}

class SlideUpdate {
  final SlideDirection slideDirection;
  final double slidePercent;
  final UpdateType updateType;
  final bool forceAnimate;

  SlideUpdate(this.updateType, this.slideDirection, this.slidePercent, this.forceAnimate);
}

enum TransitionGoal {
  open,
  close,
}

class AnimatedPageDragger {
  static const PERCENT_PER_MILLISECOND = 0.005;

  final slideDirection;
  final transitionGoal;

  AnimationController completionAnimationController;

  AnimatedPageDragger({
    this.slideDirection,
    this.transitionGoal,
    slidePercent,
    StreamController<SlideUpdate> slideUpdateStream,
    TickerProvider vsync,
  }) {
    final startSlidePercent = slidePercent;
    var endSlidePercent;
    var slideRemaining;
    var duration;

    if (transitionGoal == TransitionGoal.open) {
      endSlidePercent = 1.0;
      slideRemaining = 1.0 - slidePercent;
    } else {
      endSlidePercent = 0.0;
      slideRemaining = slidePercent;
    }

    duration = new Duration(
      milliseconds: (slideRemaining / PERCENT_PER_MILLISECOND).round(),
    );

    completionAnimationController = new AnimationController(
      vsync: vsync,
      duration: duration,
    )
      ..addListener(() {
        final slidePercent = lerpDouble(startSlidePercent, endSlidePercent, completionAnimationController.value);
        slideUpdateStream.add(new SlideUpdate(
          UpdateType.animating,
          slideDirection,
          slidePercent,
          false,
        ));
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          slideUpdateStream.add(new SlideUpdate(
            UpdateType.doneAnimating,
            slideDirection,
            endSlidePercent,
            false,
          ));
        }
      });
  }

  run() {
    if(!disposed) {
    completionAnimationController.forward(from: 0.0);
    }
  }

  bool disposed = false;
  dispose() {
    disposed = true;
    completionAnimationController.dispose();
  }
}
