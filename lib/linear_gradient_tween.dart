
import 'package:flutter/material.dart';

/// An interpolation between two LinearGradients.
///
/// This class specializes the interpolation of [Tween] to use
/// [LinearGradient.lerp].
///
/// See [Tween] for a discussion on how to use interpolation objects.
class LinearGradientTween extends Tween<LinearGradient> {
  /// Provide a begin and end Gradient. To fade between.
  LinearGradientTween({
    LinearGradient begin,
    LinearGradient end,
  }) : super(begin: begin, end: end);

  @override
  LinearGradient lerp(double t) => LinearGradient.lerp(begin, end, t);
}