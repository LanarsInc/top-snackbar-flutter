import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

const kDefaultAnimationDuration = Duration(milliseconds: 1200);
const kDefaultDisplayDuration = Duration(milliseconds: 3000);
const kDefaultReverseAnimationDuration = Duration(milliseconds: 550);
const kDefaultSnackBarPadding = EdgeInsets.all(16);

const kTapBounceDelay = Duration(milliseconds: 200);
const kFrame = Duration(milliseconds: 16);
const kFrameLag = Duration(milliseconds: 100);
const kFlingDistance = 300.0;
const kFlingSpeed = 1000.0;

Future<void> tapAndWait(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pump(kTapBounceDelay + kFrame);
}

Future<void> pumpFrames(WidgetTester tester, Duration duration) async {
  for (var elapsed = Duration.zero; elapsed < duration; elapsed += kFrame) {
    await tester.pump(kFrame);
  }
}

Size screenSize(WidgetTester tester) => tester.view.physicalSize / tester.view.devicePixelRatio;

void setScreenSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size * tester.view.devicePixelRatio;
  addTearDown(tester.view.reset);
}
