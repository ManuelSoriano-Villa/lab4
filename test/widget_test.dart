import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mortgage_app/main.dart';
import 'package:mortgage_app/mortgage.dart';

void main() {
  test('monthly payment for the default mortgage', () {
    Mortgage mortgage = Mortgage();
    expect(mortgage.formattedMonthlyPayment(), '\$449.04');
  });

  testWidgets('first screen shows the default values', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('\$100000.00'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);
    expect(find.text('3.50%'), findsOneWidget);
    expect(find.text('\$449.04'), findsOneWidget);
    expect(find.text('Modify Data'), findsOneWidget);
  });

  testWidgets('modify button only works after accepting the terms', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // button starts disabled
    ElevatedButton button = tester.widget(find.byType(ElevatedButton));
    expect(button.onPressed, null);

    // check the box and press Accept
    await tester.tap(find.text('Terms and Conditions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Accept'));
    await tester.pumpAndSettle();

    // now the button works
    button = tester.widget(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });
}
