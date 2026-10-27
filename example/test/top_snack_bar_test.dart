import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_snackbar_flutter/safe_area_values.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'test_helpers.dart';

const _snackKey = Key('snack');
const _snackHeight = 50.0;
const _snack = SizedBox(key: _snackKey, height: _snackHeight, child: Text('snack'));
final _snackFinder = find.byKey(_snackKey);

const _timingMargin = Duration(milliseconds: 100);

Future<OverlayState> _pumpHost(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: Scaffold()));
  return tester.state<OverlayState>(find.byType(Overlay).first);
}

Animation<Offset> _slidePosition(WidgetTester tester) {
  final slide = find.ancestor(of: _snackFinder, matching: find.byType(SlideTransition)).first;
  return tester.widget<SlideTransition>(slide).position;
}

Rect _expectedRect(
  WidgetTester tester, {
  EdgeInsets padding = kDefaultSnackBarPadding,
  SnackBarPosition position = SnackBarPosition.top,
  double topInset = 0,
}) {
  final screen = screenSize(tester);
  final top = switch (position) {
    SnackBarPosition.top => padding.top + topInset,
    SnackBarPosition.bottom => screen.height - padding.bottom - _snackHeight,
  };
  return Rect.fromLTWH(padding.left, top, screen.width - padding.horizontal, _snackHeight);
}

void main() {
  group('lifecycle', () {
    testWidgets('shows the child, hides it after the default durations and calls onDismissed once', (tester) async {
      final overlay = await _pumpHost(tester);
      var dismissed = 0;

      showTopSnackBar(overlay, _snack, onDismissed: () => dismissed++);
      await tester.pump();
      expect(_snackFinder, findsOneWidget);

      await pumpFrames(tester, kDefaultAnimationDuration + kDefaultDisplayDuration - _timingMargin);
      expect(_snackFinder, findsOneWidget);
      expect(dismissed, 0);

      await pumpFrames(tester, _timingMargin + kDefaultReverseAnimationDuration + kFrameLag);
      expect(_snackFinder, findsNothing);
      expect(dismissed, 1);
    });

    testWidgets('respects custom animation, display and reverse durations', (tester) async {
      final overlay = await _pumpHost(tester);
      const animationDuration = Duration(milliseconds: 200);
      const displayDuration = Duration(milliseconds: 500);
      const reverseAnimationDuration = Duration(milliseconds: 200);
      var dismissed = 0;

      showTopSnackBar(
        overlay,
        _snack,
        animationDuration: animationDuration,
        displayDuration: displayDuration,
        reverseAnimationDuration: reverseAnimationDuration,
        onDismissed: () => dismissed++,
      );
      await tester.pump();
      await pumpFrames(tester, animationDuration + displayDuration - _timingMargin);
      expect(_snackFinder, findsOneWidget);

      await pumpFrames(tester, _timingMargin + reverseAnimationDuration + kFrameLag);
      expect(_snackFinder, findsNothing);
      expect(dismissed, 1);
    });

    testWidgets('onAnimationControllerInit exposes the controller with the configured durations', (tester) async {
      final overlay = await _pumpHost(tester);
      const animationDuration = Duration(milliseconds: 700);
      const reverseAnimationDuration = Duration(milliseconds: 300);
      AnimationController? controller;

      showTopSnackBar(
        overlay,
        _snack,
        animationDuration: animationDuration,
        reverseAnimationDuration: reverseAnimationDuration,
        onAnimationControllerInit: (c) => controller = c,
      );
      await tester.pump();

      expect(controller, isNotNull);
      expect(controller!.duration, animationDuration);
      expect(controller!.reverseDuration, reverseAnimationDuration);
      expect(controller!.status, AnimationStatus.forward);
    });

    testWidgets('persistent snackbar ignores displayDuration and is dismissed via its controller', (tester) async {
      final overlay = await _pumpHost(tester);
      late AnimationController controller;
      var dismissed = 0;

      showTopSnackBar(
        overlay,
        _snack,
        persistent: true,
        onAnimationControllerInit: (c) => controller = c,
        onDismissed: () => dismissed++,
      );
      await tester.pumpAndSettle();
      await tester.pump(kDefaultDisplayDuration * 10);
      expect(_snackFinder, findsOneWidget);
      expect(dismissed, 0);

      controller.reverse();
      await tester.pumpAndSettle();

      expect(_snackFinder, findsNothing);
      expect(dismissed, 1);
    });
  });

  group('replacing', () {
    testWidgets('a new snackbar replaces the visible one', (tester) async {
      final overlay = await _pumpHost(tester);

      showTopSnackBar(overlay, const Text('first'));
      await tester.pumpAndSettle();
      showTopSnackBar(overlay, const Text('second'));
      await tester.pumpAndSettle();

      expect(find.text('first'), findsNothing);
      expect(find.text('second'), findsOneWidget);
    });

    testWidgets('only the last of several quickly shown snackbars stays on screen', (tester) async {
      final overlay = await _pumpHost(tester);
      const count = 5;
      const interval = Duration(milliseconds: 50);

      for (var i = 0; i < count; i++) {
        showTopSnackBar(overlay, Text('snack $i'));
        await tester.pump(interval);
      }
      await tester.pumpAndSettle();

      for (var i = 0; i < count - 1; i++) {
        expect(find.text('snack $i'), findsNothing);
      }
      expect(find.text('snack ${count - 1}'), findsOneWidget);
    });

    // Regression test for LanarsInc/top-snackbar-flutter#83: the new snackbar is shown in the exact frame
    // where the previous one finishes its exit animation, before the overlay rebuilds.
    testWidgets('replacing a snackbar in the frame its exit animation ends does not remove its entry twice', (
      tester,
    ) async {
      final overlay = await _pumpHost(tester);
      late AnimationController firstController;
      var firstDismissed = 0;
      var secondDismissed = 0;

      showTopSnackBar(
        overlay,
        const Text('first'),
        persistent: true,
        onAnimationControllerInit: (c) => firstController = c,
        onDismissed: () => firstDismissed++,
      );
      await tester.pumpAndSettle();

      var replaced = false;
      firstController.addListener(() {
        if (firstController.isDismissed && !replaced) {
          replaced = true;
          showTopSnackBar(overlay, const Text('second'), persistent: true, onDismissed: () => secondDismissed++);
        }
      });
      firstController.reverse();
      await tester.pumpAndSettle();

      expect(replaced, isTrue);
      expect(tester.takeException(), isNull);
      expect(find.text('first'), findsNothing);
      expect(find.text('second'), findsOneWidget);
      expect(firstDismissed, 1);
      expect(secondDismissed, 0);

      showTopSnackBar(overlay, const Text('third'));
      await tester.pumpAndSettle();
      expect(find.text('second'), findsNothing);
      expect(find.text('third'), findsOneWidget);
    });
  });

  group('DismissType.onTap', () {
    testWidgets('tap calls onTap and dismisses the snackbar', (tester) async {
      final overlay = await _pumpHost(tester);
      var taps = 0;
      var dismissed = 0;

      showTopSnackBar(overlay, _snack, onTap: () => taps++, onDismissed: () => dismissed++);
      await tester.pumpAndSettle();
      await tapAndWait(tester, _snackFinder);
      await tester.pumpAndSettle();

      expect(taps, 1);
      expect(dismissed, 1);
      expect(_snackFinder, findsNothing);
    });

    testWidgets('tap on a persistent snackbar calls onTap but keeps it visible', (tester) async {
      final overlay = await _pumpHost(tester);
      var taps = 0;

      showTopSnackBar(overlay, _snack, persistent: true, onTap: () => taps++);
      await tester.pumpAndSettle();
      await tapAndWait(tester, _snackFinder);
      await tester.pumpAndSettle();

      expect(taps, 1);
      expect(_snackFinder, findsOneWidget);
    });
  });

  group('DismissType.none', () {
    testWidgets('tap calls onTap without dismissing, the snackbar still hides on its own', (tester) async {
      final overlay = await _pumpHost(tester);
      var taps = 0;

      showTopSnackBar(overlay, _snack, dismissType: DismissType.none, onTap: () => taps++);
      await tester.pumpAndSettle();
      await tapAndWait(tester, _snackFinder);
      await tester.pumpAndSettle();

      expect(taps, 1);
      expect(_snackFinder, findsOneWidget);

      await tester.pump(kDefaultDisplayDuration);
      await tester.pumpAndSettle();
      expect(_snackFinder, findsNothing);
    });
  });

  group('DismissType.onSwipe', () {
    testWidgets('swiping up dismisses the snackbar by default', (tester) async {
      final overlay = await _pumpHost(tester);
      var dismissed = 0;

      showTopSnackBar(overlay, _snack, dismissType: DismissType.onSwipe, onDismissed: () => dismissed++);
      await tester.pumpAndSettle();
      await tester.fling(_snackFinder, const Offset(0, -kFlingDistance), kFlingSpeed);
      await tester.pumpAndSettle();

      expect(_snackFinder, findsNothing);
      expect(dismissed, 1);
    });

    testWidgets('swiping in a direction that is not allowed keeps the snackbar', (tester) async {
      final overlay = await _pumpHost(tester);

      showTopSnackBar(overlay, _snack, dismissType: DismissType.onSwipe);
      await tester.pumpAndSettle();
      await tester.fling(_snackFinder, const Offset(-kFlingDistance, 0), kFlingSpeed);
      await tester.pumpAndSettle();

      expect(_snackFinder, findsOneWidget);
    });

    testWidgets('custom dismissDirection allows swiping end to start', (tester) async {
      final overlay = await _pumpHost(tester);

      showTopSnackBar(
        overlay,
        _snack,
        dismissType: DismissType.onSwipe,
        dismissDirection: const [DismissDirection.endToStart],
      );
      await tester.pumpAndSettle();
      await tester.fling(_snackFinder, const Offset(-kFlingDistance, 0), kFlingSpeed);
      await tester.pumpAndSettle();

      expect(_snackFinder, findsNothing);
    });

    testWidgets('swiping down plays the reverse animation and dismisses the snackbar', (tester) async {
      final overlay = await _pumpHost(tester);
      var dismissed = 0;

      showTopSnackBar(
        overlay,
        _snack,
        dismissType: DismissType.onSwipe,
        dismissDirection: const [DismissDirection.down],
        snackBarPosition: SnackBarPosition.bottom,
        onDismissed: () => dismissed++,
      );
      await tester.pumpAndSettle();
      await tester.fling(_snackFinder, const Offset(0, kFlingDistance), kFlingSpeed);
      await tester.pumpAndSettle();

      expect(_snackFinder, findsNothing);
      expect(dismissed, 1);
    });

    testWidgets('persistent snackbar cannot be swiped away', (tester) async {
      final overlay = await _pumpHost(tester);

      showTopSnackBar(overlay, _snack, dismissType: DismissType.onSwipe, persistent: true);
      await tester.pumpAndSettle();
      await tester.fling(_snackFinder, const Offset(0, -kFlingDistance), kFlingSpeed);
      await tester.pumpAndSettle();

      expect(_snackFinder, findsOneWidget);
    });

    testWidgets('tap calls onTap', (tester) async {
      final overlay = await _pumpHost(tester);
      var taps = 0;

      showTopSnackBar(overlay, _snack, dismissType: DismissType.onSwipe, onTap: () => taps++);
      await tester.pumpAndSettle();
      await tapAndWait(tester, _snackFinder);

      expect(taps, 1);
    });
  });

  group('layout', () {
    testWidgets('is placed at the top with the default padding', (tester) async {
      final overlay = await _pumpHost(tester);

      showTopSnackBar(overlay, _snack);
      await tester.pumpAndSettle();

      expect(tester.getRect(_snackFinder), _expectedRect(tester));
    });

    testWidgets('SnackBarPosition.bottom places it at the bottom', (tester) async {
      final overlay = await _pumpHost(tester);

      showTopSnackBar(overlay, _snack, snackBarPosition: SnackBarPosition.bottom);
      await tester.pumpAndSettle();

      expect(tester.getRect(_snackFinder), _expectedRect(tester, position: SnackBarPosition.bottom));
    });

    testWidgets('custom padding is applied for both positions', (tester) async {
      final overlay = await _pumpHost(tester);
      const padding = EdgeInsets.fromLTRB(10, 20, 30, 40);

      showTopSnackBar(overlay, _snack, padding: padding);
      await tester.pumpAndSettle();
      expect(tester.getRect(_snackFinder), _expectedRect(tester, padding: padding));

      showTopSnackBar(overlay, _snack, padding: padding, snackBarPosition: SnackBarPosition.bottom);
      await tester.pumpAndSettle();
      expect(tester.getRect(_snackFinder), _expectedRect(tester, padding: padding, position: SnackBarPosition.bottom));
    });

    testWidgets('layout follows the screen size', (tester) async {
      setScreenSize(tester, const Size(390, 844));
      final overlay = await _pumpHost(tester);

      showTopSnackBar(overlay, _snack, snackBarPosition: SnackBarPosition.bottom);
      await tester.pumpAndSettle();

      expect(tester.getRect(_snackFinder), _expectedRect(tester, position: SnackBarPosition.bottom));
    });
  });

  group('animation', () {
    const duration = Duration(milliseconds: 1000);

    testWidgets('top snackbar slides in from above using the given curve', (tester) async {
      final overlay = await _pumpHost(tester);

      showTopSnackBar(overlay, _snack, curve: Curves.linear, animationDuration: duration);
      await tester.pump();
      expect(_slidePosition(tester).value, const Offset(0, -1));

      await tester.pump(duration ~/ 2);
      expect(_slidePosition(tester).value.dy, closeTo(-0.5, 0.01));

      await tester.pumpAndSettle();
      expect(_slidePosition(tester).value, Offset.zero);
    });

    testWidgets('bottom snackbar slides in from below', (tester) async {
      final overlay = await _pumpHost(tester);

      showTopSnackBar(overlay, _snack, snackBarPosition: SnackBarPosition.bottom);
      await tester.pump();
      expect(_slidePosition(tester).value, const Offset(0, 1));

      await tester.pumpAndSettle();
      expect(_slidePosition(tester).value, Offset.zero);
    });

    testWidgets('reverse animation uses reverseCurve', (tester) async {
      final overlay = await _pumpHost(tester);
      late AnimationController controller;

      showTopSnackBar(
        overlay,
        _snack,
        persistent: true,
        reverseCurve: Curves.linear,
        reverseAnimationDuration: duration,
        onAnimationControllerInit: (c) => controller = c,
      );
      await tester.pumpAndSettle();

      controller.reverse();
      await tester.pump();
      await tester.pump(duration ~/ 2);
      expect(_slidePosition(tester).value.dy, closeTo(-0.5, 0.01));

      await tester.pumpAndSettle();
    });
  });

  group('safe area', () {
    test('SafeAreaValues defaults match SafeArea defaults', () {
      const values = SafeAreaValues();
      expect(values.left, isTrue);
      expect(values.top, isTrue);
      expect(values.right, isTrue);
      expect(values.bottom, isTrue);
      expect(values.minimum, EdgeInsets.zero);
      expect(values.maintainBottomViewPadding, isFalse);
    });

    testWidgets('safeAreaValues are passed to the SafeArea around the child', (tester) async {
      final overlay = await _pumpHost(tester);
      const values = SafeAreaValues(
        left: false,
        top: false,
        right: false,
        bottom: false,
        minimum: EdgeInsets.all(4),
        maintainBottomViewPadding: true,
      );

      showTopSnackBar(overlay, _snack, safeAreaValues: values);
      await tester.pumpAndSettle();

      final safeArea = tester.widget<SafeArea>(find.ancestor(of: _snackFinder, matching: find.byType(SafeArea)).first);
      expect(safeArea.left, values.left);
      expect(safeArea.top, values.top);
      expect(safeArea.right, values.right);
      expect(safeArea.bottom, values.bottom);
      expect(safeArea.minimum, values.minimum);
      expect(safeArea.maintainBottomViewPadding, values.maintainBottomViewPadding);
    });

    testWidgets('the top system inset is respected by default and can be ignored', (tester) async {
      const topInset = 50.0;
      tester.view.padding = FakeViewPadding(top: topInset * tester.view.devicePixelRatio);
      addTearDown(tester.view.reset);
      final overlay = await _pumpHost(tester);

      showTopSnackBar(overlay, _snack);
      await tester.pumpAndSettle();
      expect(tester.getRect(_snackFinder), _expectedRect(tester, topInset: topInset));

      showTopSnackBar(overlay, _snack, safeAreaValues: const SafeAreaValues(top: false));
      await tester.pumpAndSettle();
      expect(tester.getRect(_snackFinder), _expectedRect(tester));
    });
  });

  testWidgets('accepts any widget as the child', (tester) async {
    final overlay = await _pumpHost(tester);

    showTopSnackBar(
      overlay,
      const Material(
        child: ListTile(leading: Icon(Icons.star), title: Text('custom')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('custom'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
  });
}
