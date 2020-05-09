import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ef/main.dart';

void main() {
  testWidgets('NavBar calls right Widgets', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(App());

    // Verify that App starts on the Homescreen.
    expect(find.text('Home'), findsOneWidget);

    // Tap the 'Card' Icon leads to transactions.
    await tester.tap(find.byIcon(Icons.credit_card));
    await tester.pump();
    expect(find.text('Transactions'), findsOneWidget);

    // Tap the 'Diagram' Icon leads to diagrams.
    await tester.tap(find.byIcon(Icons.donut_small));
    await tester.pump();
    expect(find.text('Diagrams'), findsOneWidget);

    // Tap the 'Settings' Icon leads to settings.
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pump();
    expect(find.text('Settings'), findsOneWidget);
  });
}
