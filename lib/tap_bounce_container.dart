import 'dart:async';

import 'package:flutter/cupertino.dart';

/// Widget for nice tap effect. It decrease widget scale while tapping
class TapBounceContainer extends StatefulWidget {
  const TapBounceContainer({
    Key? key,
    required this.child,
    this.onTap,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onTap;

  @override
  TapBounceContainerState createState() => TapBounceContainerState();
}

/// State for a [TapBounceContainer].
class TapBounceContainerState extends State<TapBounceContainer>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  final animationDuration = const Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: animationDuration,
      upperBound: 0.04,
    )..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onPanEnd: _onPanEnd,
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    if (mounted) {
      _controller.forward();
    }
  }

  Future<void> _onTapUp(TapUpDetails details) async {
    if (mounted) {
      unawaited(_controller.reverse());
      await Future.delayed(animationDuration);
      widget.onTap?.call();
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (mounted) {
      _controller.reverse();
    }
  }
}
