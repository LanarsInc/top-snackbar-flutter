import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

import 'package:top_snackbar_flutter_example/main.dart';

import 'test_helpers.dart';

/// Logical size of an iPhone 14: tall enough that a shown snackbar never covers the buttons.
const _phoneScreen = Size(390, 844);

const _showInfo = 'Show info';
const _showSuccess = 'Show success';
const _showError = 'Show error';
const _showPersistent = 'Show persistent SnackBar';
const _dismissPersistent = 'Dismiss persistent SnackBar';
const _showSwipeable = 'Show swiped dismissible SnackBar';

const _infoMessage = 'There is some information. You need to do something with that';
const _successMessage = 'Good job, your release is successful. Have a nice day';
const _errorMessage = 'Something went wrong. Please check your credentials and try again';
const _persistentMessage = 'Persistent SnackBar';
const _swipeableMessage = 'Try to swipe me left';

Future<void> _pumpApp(WidgetTester tester) async {
  setScreenSize(tester, _phoneScreen);
  await tester.pumpWidget(const MyApp());
}

Future<void> _tapAndSettle(WidgetTester tester, String text) async {
  await tapAndWait(tester, find.text(text));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows all demo buttons', (tester) async {
    await _pumpApp(tester);

    for (final label in [_showInfo, _showSuccess, _showError, _showPersistent, _dismissPersistent, _showSwipeable]) {
      expect(find.text(label), findsOneWidget);
    }
  });

  final cases = {
    _showInfo: (_infoMessage, Icons.sentiment_neutral),
    _showSuccess: (_successMessage, Icons.sentiment_very_satisfied),
    _showError: (_errorMessage, Icons.error_outline),
  };
  for (final MapEntry(key: button, value: (message, icon)) in cases.entries) {
    testWidgets('"$button" shows its snackbar, which hides on its own', (tester) async {
      await _pumpApp(tester);

      await _tapAndSettle(tester, button);
      expect(find.text(message), findsOneWidget);
      expect(find.byIcon(icon), findsOneWidget);

      await tester.pump(kDefaultDisplayDuration);
      await tester.pumpAndSettle();
      expect(find.byType(CustomSnackBar), findsNothing);
    });
  }

  testWidgets('tapping a snackbar dismisses it', (tester) async {
    await _pumpApp(tester);

    await _tapAndSettle(tester, _showInfo);
    await _tapAndSettle(tester, _infoMessage);

    expect(find.text(_infoMessage), findsNothing);
  });

  testWidgets('a new snackbar replaces the current one', (tester) async {
    await _pumpApp(tester);

    await _tapAndSettle(tester, _showInfo);
    await _tapAndSettle(tester, _showError);

    expect(find.text(_infoMessage), findsNothing);
    expect(find.text(_errorMessage), findsOneWidget);
  });

  testWidgets('persistent snackbar stays until "$_dismissPersistent" is tapped', (tester) async {
    await _pumpApp(tester);

    await _tapAndSettle(tester, _showPersistent);
    await tester.pump(kDefaultDisplayDuration * 10);
    expect(find.text(_persistentMessage), findsOneWidget);

    await _tapAndSettle(tester, _dismissPersistent);
    expect(find.text(_persistentMessage), findsNothing);
  });

  testWidgets('tapping a persistent snackbar does not dismiss it', (tester) async {
    await _pumpApp(tester);

    await _tapAndSettle(tester, _showPersistent);
    await _tapAndSettle(tester, _persistentMessage);

    expect(find.text(_persistentMessage), findsOneWidget);
  });

  testWidgets('"$_dismissPersistent" before showing one does nothing', (tester) async {
    await _pumpApp(tester);

    await _tapAndSettle(tester, _dismissPersistent);

    expect(tester.takeException(), isNull);
    expect(find.byType(CustomSnackBar), findsNothing);
  });

  testWidgets('swipe-dismissible snackbar is dismissed by swiping left only', (tester) async {
    await _pumpApp(tester);

    await _tapAndSettle(tester, _showSwipeable);
    expect(find.text(_swipeableMessage), findsOneWidget);

    await tester.fling(find.text(_swipeableMessage), const Offset(kFlingDistance, 0), kFlingSpeed);
    await tester.pumpAndSettle();
    expect(find.text(_swipeableMessage), findsOneWidget);

    await tester.fling(find.text(_swipeableMessage), const Offset(-kFlingDistance, 0), kFlingSpeed);
    await tester.pumpAndSettle();
    expect(find.text(_swipeableMessage), findsNothing);
  });
}
