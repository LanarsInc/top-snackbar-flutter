import 'package:flutter/widgets.dart';

/// Wraps an [OverlayEntry] so it is removed and disposed at most once.
class SnackBarEntry {
  SnackBarEntry(this.overlayEntry);

  final OverlayEntry overlayEntry;

  bool _isRemoved = false;

  void remove() {
    if (_isRemoved) return;

    _isRemoved = true;
    overlayEntry.remove();
    overlayEntry.dispose();
  }
}
