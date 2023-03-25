import 'dart:math';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:integration_test/integration_test.dart';
import 'package:clock/clock.dart';
import 'package:isar/isar.dart';

import 'package:scripture_app/main.dart' as app;
import 'package:scripture_app/scripture_form.dart';

var editButton = find.byTooltip('Edit collection name');
var addButton = find.byTooltip('Add a verse', skipOffstage: false);
var deleteButton = find.byIcon(Icons.delete, skipOffstage: false);
var collectionsButton = find.byTooltip('Your Collections');

var ok = find.text('OK');
var cancel = find.text('Cancel');
var submit = find.text('Submit');
var textField = find.byType(TextField);

// could use hints probably instead of keys or textfields[0] and textfields[1]
var textFieldScriptureToAdd = find.byKey(keyScriptureRefToAdd);
var textFieldCollectionName = find.byKey(keyCollectionName);


Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await Isar.initializeIsarCore(download: true);
  group('Edit Collection Name', () {
    // NOTE: These are probably good candidates for widget tests sooner than later.

    testWidgets('Edit collection '
        'name and tap OK, new name shows, cancel it does not',
            (tester) async {
              await app.main();
              await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
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
              // TODO: Test that switch collections shwos the correct name as grey.

            });

    // todo: look into https://github.com/isar/isar#unit-tests and trying to make it separate tests
    // instead of one e2e test.

  });
  group('Add Verse/Collection', (){
    testWidgets("Add/Remove a verse to MyList", (tester) async {
      await app.main();
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
      // Note: always use clock.now instead of datetime.now() esp in SUT
      String scripture = "Genesis 1:1";

      // Add the verse
      await tester.pumpAndSettle();
      expect(find.text(scripture), findsNothing);
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text('My List'), findsOneWidget);
      await enterVerseToAdd(tester, scripture, "My List");
      await tester.tap(submit);
      await tester.pumpAndSettle();
      expect(find.text(scripture), findsOneWidget);

      // Remove the verse
      await tester.drag(find.text(scripture), const Offset(500.0, 0.0));
      await tester.tap(deleteButton);
      expect(find.text(scripture), findsNothing);
      
    });
    testWidgets("Add a verse to new collection", (tester) async {
      await app.main();
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
      // Note: always use clock.now instead of datetime.now() esp in SUT
      String scripture = "Genesis 1:1";
      String collection = "test";

      await tester.pumpAndSettle();
      expect(find.text(scripture), findsNothing);
      expect(find.text('My List'), findsOneWidget);
      await enterVerseToAdd(tester, scripture, collection);
      await tester.tap(submit);
      await tester.pumpAndSettle();
      expect(find.text(scripture), findsOneWidget);
      expect(find.text(collection), findsOneWidget);
      await tester.tap(collectionsButton);
      expect(find.text(collection), findsOneWidget);
    });
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

Future<void> enterVerseToAdd(WidgetTester tester, String reference, String collection) async {

  await tester.pumpAndSettle(const Duration(seconds: 4));

  expect(find.text('Scripture App', skipOffstage: true), findsOneWidget);
  expect(addButton, findsOneWidget);
  await tester.tap(addButton);
  await tester.pumpAndSettle(const Duration(seconds: 1));
  expect (textFieldScriptureToAdd, findsOneWidget);

  await tester.enterText(textFieldScriptureToAdd, reference);
  await tester.pumpAndSettle(const Duration(seconds: 1));

  expect(submit, findsOneWidget);

}