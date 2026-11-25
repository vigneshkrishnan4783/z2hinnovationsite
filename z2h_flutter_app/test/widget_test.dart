import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:z2h_flutter_app/data/z2h_data.dart';
import 'package:z2h_flutter_app/main.dart';
import 'package:z2h_flutter_app/widgets/z2h_strategy_visual.dart';

void main() {
  testWidgets(
      'Z2H app removes top nav and side square box, animates header/bg bubbles on cursor move, and reveals borderless side wave nav',
      (WidgetTester tester) async {
    Future<void> verifyAtSize(Size size) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const Z2HApp());
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.byType(NavigationRail), findsNothing);
      expect(find.byType(FloatingActionButton), findsNothing);
      expect(find.byIcon(Icons.support_agent_rounded), findsNothing);
      expect(find.text('Customer Care Chat'), findsNothing);
      expect(find.text('Navigation'), findsNothing);
      expect(find.text('FLUTTER // ARCHITECTURE_2026'), findsNothing);

      expect(find.text(Z2HData.heroHeadline), findsOneWidget);
      expect(find.text('Explore Capabilities'), findsOneWidget);
      expect(find.text('4-in-1'), findsOneWidget);
      expect(find.text('2x Model'), findsOneWidget);
      expect(find.text('24/7'), findsOneWidget);
      expect(find.byType(Z2HStrategyVisual), findsOneWidget);
      expect(find.text('M37, Kuruvankonam, Kowdiar'), findsOneWidget);
      expect(find.text('Powered by Z2H 2026'), findsOneWidget);
    }

    await verifyAtSize(const Size(390, 844));
    await verifyAtSize(const Size(820, 1024));
    await verifyAtSize(const Size(1440, 900));

    // Move cursor onto top header -> triggers header bubbles + Z2H hover, NO top navigation shown
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: const Offset(400, 400));
    await tester.pump();
    await gesture.moveTo(const Offset(550, 32));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Services'), findsNothing);

    // Hover over Z2H logo
    await gesture.moveTo(const Offset(100, 38));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    // Move cursor to right edge -> reveals borderless side wave navigation -> navigate to Services
    await gesture.moveTo(const Offset(1432, 300));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Services'), findsOneWidget);
    await tester.tap(find.text('Services'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('Full-Spectrum Engineering & Applied AI Delivery'), findsOneWidget);

    // Move cursor to left edge -> reveals borderless side wave navigation -> navigate to Careers
    await gesture.moveTo(const Offset(10, 300));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('Careers'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('Deep Learning & LLM Research Engineer'), findsOneWidget);
  });
}
