import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

void main() {
  const MethodChannel channel = MethodChannel('top_snackbar_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (message) async {
      return '42';
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets(
      'showing a snackbar while the previous one finishes its exit animation does not throw',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold()));
    final overlayState = tester.state<OverlayState>(find.byType(Overlay));

    late AnimationController firstController;
    showTopSnackBar(
      overlayState,
      const Text('first'),
      animationDuration: const Duration(milliseconds: 100),
      reverseAnimationDuration: const Duration(milliseconds: 100),
      persistent: true,
      onAnimationControllerInit: (controller) => firstController = controller,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    firstController.reverse();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    showTopSnackBar(overlayState, const Text('second'), persistent: true);

    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(seconds: 2));

    expect(tester.takeException(), isNull);
    expect(find.text('first'), findsNothing);
    expect(find.text('second'), findsOneWidget);
  });
}
