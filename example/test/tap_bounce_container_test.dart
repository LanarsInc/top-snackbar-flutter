import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';

import 'test_helpers.dart';

const _pressedScale = 0.96;

const _childKey = Key('child');
final _childFinder = find.byKey(_childKey);

Future<void> _pumpContainer(WidgetTester tester, {VoidCallback? onTap}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Center(
        child: TapBounceContainer(
          onTap: onTap,
          child: const ColoredBox(key: _childKey, color: Colors.blue, child: SizedBox.square(dimension: 100)),
        ),
      ),
    ),
  );
}

double _scale(WidgetTester tester) {
  final transform = tester.widget<Transform>(
    find.descendant(of: find.byType(TapBounceContainer), matching: find.byType(Transform)),
  );
  return transform.transform.entry(0, 0);
}

void main() {
  testWidgets('shrinks the child while pressed and restores it after release', (tester) async {
    await _pumpContainer(tester, onTap: () {});
    expect(_scale(tester), 1);

    final gesture = await tester.startGesture(tester.getCenter(_childFinder));
    await tester.pump(kPressTimeout);
    await tester.pumpAndSettle();
    expect(_scale(tester), closeTo(_pressedScale, 1e-6));

    await gesture.up();
    await tester.pumpAndSettle();
    expect(_scale(tester), 1);
  });

  testWidgets('calls onTap with a delay after the pointer is released', (tester) async {
    var taps = 0;
    await _pumpContainer(tester, onTap: () => taps++);

    final gesture = await tester.startGesture(tester.getCenter(_childFinder));
    await tester.pump(kPressTimeout + kTapBounceDelay);
    expect(taps, 0);

    await gesture.up();
    await tester.pump(kTapBounceDelay - kFrame);
    expect(taps, 0);

    await tester.pump(kFrame * 2);
    expect(taps, 1);
  });

  testWidgets('works without onTap', (tester) async {
    await _pumpContainer(tester);

    await tapAndWait(tester, _childFinder);

    expect(tester.takeException(), isNull);
  });

  testWidgets('dragging restores the scale and does not call onTap', (tester) async {
    var taps = 0;
    await _pumpContainer(tester, onTap: () => taps++);

    await tester.drag(_childFinder, const Offset(kFlingDistance, 0));
    await tester.pumpAndSettle();
    await tester.pump(kTapBounceDelay + kFrame);

    expect(taps, 0);
    expect(_scale(tester), 1);
  });
}
