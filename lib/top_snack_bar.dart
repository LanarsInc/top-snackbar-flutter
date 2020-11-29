import 'package:flutter/material.dart';

const _showOutAnimationDuration = Duration(milliseconds: 1200);
const _hideOutAnimationDuration = Duration(milliseconds: 300);
const _messageDisplayDuration = Duration(milliseconds: 1500);

void showTopSnackBar(BuildContext context, Widget child) async {
  final overlayState = Overlay.of(context);
  OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) {
      return TopSnackBar(
        child: child,
        onDismissed: () {
          overlayEntry.remove();
        },
      );
    },
  );

  overlayState.insert(overlayEntry);
}

class TopSnackBar extends StatefulWidget {
  final Widget child;
  final VoidCallback onDismissed;

  TopSnackBar({
    Key key,
    @required this.child,
    @required this.onDismissed,
  }) : super(key: key);

  @override
  _TopSnackBarState createState() => _TopSnackBarState();
}

class _TopSnackBarState extends State<TopSnackBar> with SingleTickerProviderStateMixin {
  Animation offsetAnimation;
  AnimationController animationController;
  double topPosition = 8;

  @override
  void initState() {
    _setupAndStartAnimation();
    super.initState();
  }

  void _setupAndStartAnimation() async {
    animationController = AnimationController(
      vsync: this,
      duration: _showOutAnimationDuration,
      reverseDuration: _hideOutAnimationDuration,
    );

    Tween<Offset> offsetTween = Tween<Offset>(
      begin: Offset(0.0, -1.0),
      end: Offset(0.0, 0.0),
    );

    offsetAnimation = offsetTween.animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.elasticOut,
        reverseCurve: Curves.linearToEaseOut,
      ),
    )..addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          await Future.delayed(_messageDisplayDuration);
          animationController.reverse();
          setState(() {
            topPosition = 0;
          });
        }

        if (status == AnimationStatus.dismissed) {
          widget.onDismissed.call();
        }
      });

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: _hideOutAnimationDuration * 1.5,
      curve: Curves.linearToEaseOut,
      top: topPosition,
      left: 16.0,
      right: 16.0,
      child: SlideTransition(
        position: offsetAnimation,
        child: SafeArea(
          child: widget.child,
        ),
      ),
    );
  }
}
