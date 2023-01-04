import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:clock/clock.dart';

import 'package:scripture_app/main.dart' as app;

var editButton = find.byTooltip('Edit collection name');

var ok = find.text('OK');
var cancel = find.text('Cancel');
var textField = find.byType(TextField);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Edit Collection Name', () {
    // NOTE: These are probably good candidates for widget tests sooner than later.

    testWidgets('Edit collection name and tap OK, new name shows.',
            (tester) async {
              app.main();
              // Note: always use clock.now instead of datetime.now() esp in SUT
              String newName = 'newName${clock.now()}';
              await launchAndEditName(tester,newName);
              await tester.tap(ok);
              await tester.pumpAndSettle();
              expect(find.text(newName), findsOneWidget);
              await tester.pumpAndSettle(const Duration(seconds: 8));

            });

    testWidgets('Edit collection name and tap cancel - new name not present',
            (tester) async {
              app.main();
              String newName = 'newName${clock.now()}';
              await launchAndEditName(tester, newName);
              await tester.tap(cancel);
              await tester.pumpAndSettle();
              expect(find.text(newName), findsNothing);
              await tester.pumpAndSettle(const Duration(seconds: 8));
            });
  });
}


Future<void> launchAndEditName(WidgetTester tester, String newName) async {

  await tester.pumpAndSettle(const Duration(seconds: 5));

  expect(find.text('Scripture App', skipOffstage: true), findsOneWidget);
  expect(editButton, findsOneWidget);
  await tester.tap(editButton);
  await tester.pumpAndSettle(const Duration(seconds: 2));
  expect (textField, findsOneWidget);

  await tester.enterText(textField, newName);
  await tester.pumpAndSettle(const Duration(seconds: 2));

  expect(ok, findsOneWidget);
  expect(cancel, findsOneWidget);

}