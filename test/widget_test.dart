import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bus_booking/core/utils/currency_formatter.dart';
import 'package:bus_booking/core/utils/date_formatter.dart';
import 'package:bus_booking/core/utils/pnr_generator.dart';
import 'package:bus_booking/core/utils/validators.dart';
import 'package:bus_booking/core/widgets/app_card.dart';
import 'package:bus_booking/core/widgets/custom_button.dart';
import 'package:bus_booking/core/widgets/status_badge.dart';

void main() {
  group('SmartBus Utils Tests', () {
    test('CurrencyFormatter formats INR amounts properly', () {
      expect(CurrencyFormatter.format(799), '₹799');
      expect(CurrencyFormatter.format(1499), '₹1,499');
      expect(CurrencyFormatter.format(40), '₹40');
    });

    test('DateFormatter parses and formats correctly', () {
      final date = DateTime(2026, 11, 26);
      final dbStr = DateFormatter.toDbString(date);
      expect(dbStr, '2026-11-26');

      final parsed = DateFormatter.fromDbString(dbStr);
      expect(parsed.year, 2026);
      expect(parsed.month, 11);
      expect(parsed.day, 26);
    });

    test('PnrGenerator generates valid PNR format', () {
      final pnr = PnrGenerator.generate();
      expect(pnr.startsWith('SB-'), isTrue);
      expect(pnr.length, 9); // SB- + 6 digits
    });

    test('Validators validate name correctly', () {
      expect(Validators.validateName(''), isNotNull);
      expect(Validators.validateName('Jo'), isNotNull);
      expect(Validators.validateName('John Doe'), isNull);
    });

    test('Validators validate phone number correctly', () {
      expect(Validators.validatePhone(''), isNotNull);
      expect(Validators.validatePhone('12345'), isNotNull);
      expect(Validators.validatePhone('1234567890'), isNotNull);
      expect(Validators.validatePhone('9876543210'), isNull);
    });

    test('Validators validate email correctly', () {
      expect(Validators.validateEmail(''), isNotNull);
      expect(Validators.validateEmail('invalid-email'), isNotNull);
      expect(Validators.validateEmail('user@test.com'), isNull);
    });

    test('Validators validate age correctly', () {
      expect(Validators.validateAge(''), isNotNull);
      expect(Validators.validateAge('0'), isNotNull);
      expect(Validators.validateAge('150'), isNotNull);
      expect(Validators.validateAge('25'), isNull);
    });
  });

  group('SmartBus UI Components Widget Tests', () {
    testWidgets('CustomButton renders text and triggers callback', (
      WidgetTester tester,
    ) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Search Buses',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Search Buses'), findsOneWidget);
      await tester.tap(find.text('Search Buses'));
      expect(tapped, isTrue);
    });

    testWidgets('StatusBadge displays CONFIRMED status with checkmark', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: StatusBadge(status: 'CONFIRMED')),
        ),
      );

      expect(find.text('CONFIRMED'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });

    testWidgets('AppCard renders child and responds to tap', (
      WidgetTester tester,
    ) async {
      bool cardTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCard(
              onTap: () => cardTapped = true,
              child: const Text('Delhi to Chandigarh'),
            ),
          ),
        ),
      );

      expect(find.text('Delhi to Chandigarh'), findsOneWidget);
      await tester.tap(find.text('Delhi to Chandigarh'));
      expect(cardTapped, isTrue);
    });
  });
}
