import 'package:ef/diagrams_widget.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('diagram bar calls right diagrams', (WidgetTester tester) async {
    // Build our app and goto diagrams
    await tester.pumpWidget(DiagramPage());

    // Verify that first diagram is bar-chart.
    expect(find.text('Expenditures and earnings per month'), findsOneWidget);

    // Tap the 'donut' Icon leads to donut chart.
    //await tester.tap(find.byIcon(FontAwesomeIcons.chartPie));
    //await tester.pump();
    //expect(find.text('spend'), findsOneWidget);

    // Tap the 'Line chart' Icon leads to line chart.
    //await tester.tap(find.byIcon(FontAwesomeIcons.chartLine));
    //await tester.pump();
    //expect(find.text('Sales for the first 5 years TESTDATA'), findsOneWidget);
  });
}
