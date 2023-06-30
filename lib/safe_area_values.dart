import 'package:flutter/widgets.dart';

/// A data class that is used to pass safe area values for snackbar
class SafeAreaValues {
  const SafeAreaValues({
    this.left = true,
    this.right = true,
    this.top = true,
    this.bottom = true,
    this.minimum = EdgeInsets.zero,
    this.maintainBottomViewPadding = false,
  });

  final bool left;
  final bool top;
  final bool right;
  final bool bottom;
  final EdgeInsets minimum;
  final bool maintainBottomViewPadding;
}
