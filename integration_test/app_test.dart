import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:scripture_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {

    testWidgets('Add a verse',
            (tester) async {
          app.main();
          await tester.pumpAndSettle(Duration(seconds: 5));

          expect(find.text('Scripture App', skipOffstage: true), findsOneWidget);
          await tester.tap(find.byIcon(Icons.edit));
          expect(find.byTooltip('Edit collection name'), findsOneWidget);
          await tester.pumpAndSettle(Duration(seconds: 3));
          var textfield = find.byType(TextField);
          expect (textfield, findsOneWidget);
          await tester.enterText(textfield, 'newName');
          await tester.pumpAndSettle(Duration(seconds: 3));


            });
  });
}