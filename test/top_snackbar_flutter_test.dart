import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_snackbar_flutter/top_snackbar_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('top_snackbar_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await TopSnackbarFlutter.platformVersion, '42');
  });
}
