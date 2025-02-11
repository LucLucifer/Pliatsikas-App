// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pliatsikas_app/main.dart';

void main() {
  testWidgets('App should start and show homepage', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app shows the title
    expect(find.text('Διαχείριση Παραγγελιών'), findsOneWidget);

    // Verify that we have a floating action button
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Homepage should have welcome text', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify welcome text exists
    expect(find.text('Καλώς ήρθατε!'), findsOneWidget);
  });
}
