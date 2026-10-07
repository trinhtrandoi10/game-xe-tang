import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:iron_gorge_ares_override/app/app.dart';
import 'package:iron_gorge_ares_override/app/localization.dart';
import 'package:iron_gorge_ares_override/game/application/game_session.dart';
import 'package:iron_gorge_ares_override/game/presentation/game_screen.dart';
import 'package:iron_gorge_ares_override/game/domain/save/save_game.dart';

void main() {
  testWidgets('boots the Iron Gorge shell', (WidgetTester tester) async {
    await tester.pumpWidget(const IronGorgeApp());
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('dragging the left move zone applies forward input', (
    WidgetTester tester,
  ) async {
    final session = GameSession(GameProfile.newGame());
    await tester.pumpWidget(
      MaterialApp(
        home: GameScreen(
          session: session,
          strings: AppStrings(const Locale('en')),
          onExit: () {},
          onResult: () {},
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 50));

    final gesture = await tester.startGesture(const Offset(80, 500));
    await gesture.moveTo(const Offset(80, 300));
    await tester.pump(const Duration(milliseconds: 100));
    await gesture.up();

    expect(session.player.speed, greaterThan(0));
    session.dispose();
  });
}
