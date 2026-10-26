import 'package:flutter/widgets.dart';

/// Wraps an [OverlayEntry] so it is removed and disposed at most once.
///
/// [OverlayEntry.mounted] can't be used for that: it stays true until the
/// overlay rebuilds, so a snackbar replaced by a new one can still finish its
/// exit animation in that frame and try to remove its entry a second time.
class SnackBarEntry {
  SnackBarEntry(this.overlayEntry);

  final OverlayEntry overlayEntry;
  bool _isRemoved = false;

  void remove() {
    if (_isRemoved) {
      return;
    }
    _isRemoved = true;
    overlayEntry.remove();
    overlayEntry.dispose();
  }
}
