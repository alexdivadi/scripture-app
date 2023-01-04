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

    testWidgets('Edit collection name and tap OK, new name shows, cancel it does not',
            (tester) async {
              app.main();
              // Note: always use clock.now instead of datetime.now() esp in SUT
              String newName = 'new${clock.now().millisecondsSinceEpoch}';
              await enterNameToEdit(tester,newName);
              await tester.tap(cancel);
              await tester.pumpAndSettle();
              expect(find.text(newName), findsNothing);
              await enterNameToEdit(tester, newName);
              await tester.tap(ok);
              await tester.pumpAndSettle();
              expect(find.text(newName), findsOneWidget);

            });

    // todo: look into https://github.com/isar/isar#unit-tests and trying to make it separate tests
    // instead of one e2e test.

  });
}


Future<void> enterNameToEdit(WidgetTester tester, String newName) async {

  await tester.pumpAndSettle(const Duration(seconds: 4));

  expect(find.text('Scripture App', skipOffstage: true), findsOneWidget);
  expect(editButton, findsOneWidget);
  await tester.tap(editButton);
  await tester.pumpAndSettle(const Duration(seconds: 1));
  expect (textField, findsOneWidget);

  await tester.enterText(textField, newName);
  await tester.pumpAndSettle(const Duration(seconds: 1));

  expect(ok, findsOneWidget);
  expect(cancel, findsOneWidget);

}