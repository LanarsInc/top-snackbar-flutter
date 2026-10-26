import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

import 'test_helpers.dart';

const _defaultHeight = 80.0;
const _defaultMaxLines = 2;
const _defaultMessagePadding = EdgeInsets.symmetric(horizontal: 24);
const _defaultTextStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white);
const _defaultIconRotationDegrees = 32;
const _defaultIconPositionTop = -10.0;
const _defaultIconPositionLeft = -8.0;

const _message = 'msg';

Future<void> _pumpSnackBar(WidgetTester tester, CustomSnackBar snackBar) {
  return tester.pumpWidget(MaterialApp(home: Scaffold(body: snackBar)));
}

BoxDecoration _decoration(WidgetTester tester) {
  final container = tester.widget<Container>(
    find.descendant(of: find.byType(CustomSnackBar), matching: find.byType(Container)).first,
  );
  return container.decoration! as BoxDecoration;
}

Text _messageText(WidgetTester tester) {
  return tester.widget<Text>(find.descendant(of: find.byType(CustomSnackBar), matching: find.byType(Text)));
}

EdgeInsetsGeometry _messagePadding(WidgetTester tester, String message) {
  return tester.widget<Padding>(find.ancestor(of: find.text(message), matching: find.byType(Padding)).first).padding;
}

double _rotationOf(WidgetTester tester, Finder icon) {
  final transform = tester.widget<Transform>(find.ancestor(of: icon, matching: find.byType(Transform)).first).transform;
  return atan2(transform.entry(1, 0), transform.entry(0, 0));
}

Positioned _iconPosition(WidgetTester tester, Finder icon) {
  return tester.widget<Positioned>(find.ancestor(of: icon, matching: find.byType(Positioned)).first);
}

double _degreesToRadians(num degrees) => degrees * pi / 180;

void main() {
  group('variants', () {
    final variants = <String, (CustomSnackBar, Color, IconData)>{
      'success': (
        const CustomSnackBar.success(message: _message),
        const Color(0xff00E676),
        Icons.sentiment_very_satisfied,
      ),
      'info': (const CustomSnackBar.info(message: _message), const Color(0xff2196F3), Icons.sentiment_neutral),
      'error': (const CustomSnackBar.error(message: _message), const Color(0xffff5252), Icons.error_outline),
    };

    for (final MapEntry(key: name, value: (snackBar, color, icon)) in variants.entries) {
      testWidgets('$name shows the message with its default color and icon', (tester) async {
        await _pumpSnackBar(tester, snackBar);

        expect(find.text(_message), findsOneWidget);
        expect(find.byIcon(icon), findsOneWidget);
        expect(_decoration(tester).color, color);
      });
    }
  });

  testWidgets('has the default height, full width, shape and shadow', (tester) async {
    await _pumpSnackBar(tester, const CustomSnackBar.info(message: _message));

    expect(tester.getSize(find.byType(CustomSnackBar)), Size(screenSize(tester).width, _defaultHeight));

    final decoration = _decoration(tester);
    expect(decoration.borderRadius, kDefaultBorderRadius);
    expect(decoration.boxShadow, kDefaultBoxShadow);
  });

  testWidgets('message text has the default style and layout', (tester) async {
    await _pumpSnackBar(tester, const CustomSnackBar.info(message: _message));

    final text = _messageText(tester);
    expect(text.maxLines, _defaultMaxLines);
    expect(text.overflow, TextOverflow.ellipsis);
    expect(text.textAlign, TextAlign.center);
    expect(text.textScaler, TextScaler.noScaling);
    expect(text.style?.color, _defaultTextStyle.color);
    expect(text.style?.fontSize, _defaultTextStyle.fontSize);
    expect(text.style?.fontWeight, _defaultTextStyle.fontWeight);
    expect(_messagePadding(tester, _message), _defaultMessagePadding);
  });

  testWidgets('icon is rotated and offset to the top-left by default', (tester) async {
    await _pumpSnackBar(tester, const CustomSnackBar.info(message: _message));
    final icon = find.byIcon(Icons.sentiment_neutral);

    expect(_rotationOf(tester, icon), closeTo(_degreesToRadians(_defaultIconRotationDegrees), 1e-6));
    expect(_iconPosition(tester, icon).top, _defaultIconPositionTop);
    expect(_iconPosition(tester, icon).left, _defaultIconPositionLeft);
  });

  testWidgets('applies all custom parameters', (tester) async {
    const message = 'custom message';
    const backgroundColor = Colors.purple;
    const textStyle = TextStyle(color: Colors.yellow, fontSize: 20);
    const maxLines = 1;
    const rotationDegrees = 90;
    const iconTop = 5.0;
    const iconLeft = 6.0;
    const messagePadding = EdgeInsets.all(8);
    const shadow = [BoxShadow(color: Colors.red, blurRadius: 4)];
    const radius = BorderRadius.all(Radius.circular(4));
    const textScaleFactor = 1.5;
    const textAlign = TextAlign.left;

    await _pumpSnackBar(
      tester,
      const CustomSnackBar.success(
        message: message,
        icon: Icon(Icons.star),
        backgroundColor: backgroundColor,
        textStyle: textStyle,
        maxLines: maxLines,
        iconRotationAngle: rotationDegrees,
        iconPositionTop: iconTop,
        iconPositionLeft: iconLeft,
        messagePadding: messagePadding,
        boxShadow: shadow,
        borderRadius: radius,
        textScaleFactor: textScaleFactor,
        textAlign: textAlign,
      ),
    );
    final icon = find.byIcon(Icons.star);

    expect(find.text(message), findsOneWidget);
    expect(icon, findsOneWidget);
    expect(find.byIcon(Icons.sentiment_very_satisfied), findsNothing);

    final decoration = _decoration(tester);
    expect(decoration.color, backgroundColor);
    expect(decoration.boxShadow, shadow);
    expect(decoration.borderRadius, radius);

    final text = _messageText(tester);
    expect(text.style?.color, textStyle.color);
    expect(text.style?.fontSize, textStyle.fontSize);
    expect(text.maxLines, maxLines);
    expect(text.textAlign, textAlign);
    expect(text.textScaler, const TextScaler.linear(textScaleFactor));
    expect(_messagePadding(tester, message), messagePadding);

    expect(_rotationOf(tester, icon), closeTo(_degreesToRadians(rotationDegrees), 1e-6));
    expect(_iconPosition(tester, icon).top, iconTop);
    expect(_iconPosition(tester, icon).left, iconLeft);
  });

  testWidgets('long message is truncated to maxLines without overflow errors', (tester) async {
    await _pumpSnackBar(tester, CustomSnackBar.error(message: 'Something went wrong. ' * 20));

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(CustomSnackBar)).height, _defaultHeight);
  });

  testWidgets('message style is merged with the theme text style', (tester) async {
    const letterSpacing = 3.0;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          textTheme: const TextTheme(bodyMedium: TextStyle(letterSpacing: letterSpacing)),
        ),
        home: const Scaffold(body: CustomSnackBar.info(message: _message)),
      ),
    );

    final style = _messageText(tester).style;
    expect(style?.letterSpacing, letterSpacing);
    expect(style?.color, _defaultTextStyle.color);
  });
}
