// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nfc/main.dart';

void main() {
  testWidgets('NFC Reader App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NfcReaderApp());

    // Verify that the app title is present
    expect(find.text('NFC Reader'), findsOneWidget);
    
    // Verify that the scan button exists
    expect(find.byType(ElevatedButton), findsNothing); // It's a FilledButton.icon
    expect(find.text('Scan NFC Tag'), findsOneWidget);
  });
}
