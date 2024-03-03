import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thaiqr/thaiqr.dart';

void main() {
  test('create qrcode with mobile and amount', () {
    var generator = ThaiQRGenerator();
    var code = generator.generateCodeFromMobileOrId("1234567890123", "123.45");
    expect(code.length, 84);
    expect(
        code.contains(
            "00020101021229370016A000000677010111021312345678901235802TH53037645406123.4563"),
        true);
  });

  testWidgets('Widget Test', (WidgetTester tester) async {
    // Build our widget
    await tester.pumpWidget(
      MaterialApp(
        home: ThaiQRWidget(
            mobileOrId: "1234567890123"), // Replace with your widget
      ),
    );

    // Verify that the widget renders correctly
    expect(find.byType(ThaiQRWidget), findsOneWidget);
  });
}
