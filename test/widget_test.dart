import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:iron_gorge_ares_override/app/app.dart';
import 'package:iron_gorge_ares_override/app/localization.dart';
import 'package:iron_gorge_ares_override/game/application/game_session.dart';
import 'package:iron_gorge_ares_override/game/presentation/game_screen.dart';
import 'package:iron_gorge_ares_override/game/domain/save/save_game.dart';
import 'package:iron_gorge_ares_override/features/main_menu/main_menu_screen.dart';

void main() {
  testWidgets('boots the Iron Gorge shell', (WidgetTester tester) async {
    await tester.pumpWidget(const IronGorgeApp());
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('main menu scrolls without overflow on a short window', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(914, 411);

    try {
      await tester.pumpWidget(
        MaterialApp(
          home: MainMenuScreen(
            strings: AppStrings(const Locale('en')),
            profile: GameProfile.newGame(),
            hasSave: true,
            onContinue: () {},
            onNewMission: () {},
            onGarage: () {},
            onShop: () {},
            onSettings: () {},
          ),
        ),
      );
      expect(tester.takeException(), null);

      await tester.ensureVisible(find.text('BUILD 0.1 // MVP SPIKE'));
      await tester.pump();
      expect(tester.takeException(), null);
    } finally {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    }
  });

  testWidgets('dragging inside the joystick applies forward input', (
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

    expect(session.player.speed > 0, true);
    session.dispose();
  });

  testWidgets('pressing the joystick forward moves without a drag', (
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

    final screen = tester.getSize(find.byType(GameScreen));
    final gesture = await tester.startGesture(
      Offset(101, screen.height - 26 - 85 - 60),
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(session.player.speed > 0, true);

    await gesture.up();
    for (var frame = 0; frame < 20; frame++) {
      session.tick(1 / 60);
    }
    expect(session.player.speed < 0.1, true);
    session.dispose();
  });

  testWidgets('a drag started outside the joystick cannot move the tank', (
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

    final screen = tester.getSize(find.byType(GameScreen));
    final centerY = screen.height - 26 - 85;
    final gesture = await tester.startGesture(Offset(101, centerY - 90));
    await gesture.moveTo(Offset(101, centerY - 50));
    await tester.pump(const Duration(milliseconds: 100));
    expect(session.player.speed, 0);

    await gesture.up();
    session.dispose();
  });

  testWidgets('a longer joystick drag produces a higher speed', (
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

    final screen = tester.getSize(find.byType(GameScreen));
    final center = Offset(101, screen.height - 26 - 85);
    final shortDrag = await tester.startGesture(center + const Offset(0, -25));
    for (var frame = 0; frame < 60; frame++) {
      session.tick(1 / 60);
    }
    final slowSpeed = session.player.speed;
    expect(slowSpeed > 0, true);
    await shortDrag.up();
    for (var frame = 0; frame < 60; frame++) {
      session.tick(1 / 60);
    }

    final longDrag = await tester.startGesture(center);
    await longDrag.moveTo(center + const Offset(0, -120));
    for (var frame = 0; frame < 60; frame++) {
      session.tick(1 / 60);
    }
    expect(session.player.speed > slowSpeed * 2, true);
    expect(session.player.speed > session.player.config.maxSpeed * 2.2, true);

    await longDrag.up();
    session.dispose();
  });

  testWidgets('dragging the reticle aims around the tank', (
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

    final screen = tester.getSize(find.byType(GameScreen));
    final center = Offset(screen.width * 0.5, screen.height * 0.54);
    final heading = session.player.turretHeading;
    final reticle = center + Offset(math.sin(heading), math.cos(heading)) * 90;
    final gesture = await tester.startGesture(reticle);

    await gesture.moveTo(center + const Offset(0, -90));
    expect((session.player.turretHeading - math.pi).abs() < 0.01, true);
    await gesture.moveTo(center + const Offset(-90, 0));
    expect((session.player.turretHeading + math.pi / 2).abs() < 0.01, true);
    await gesture.moveTo(center + const Offset(0, 90));
    expect(session.player.turretHeading.abs() < 0.01, true);

    await gesture.up();
    session.dispose();
  });

  testWidgets('dragging outside the reticle does not aim', (
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

    final screen = tester.getSize(find.byType(GameScreen));
    final heading = session.player.turretHeading;
    final gesture = await tester.startGesture(
      Offset(screen.width - 50, screen.height * 0.54),
    );
    await gesture.moveBy(const Offset(-100, -80));
    await tester.pump();
    expect(session.player.turretHeading, heading);

    await gesture.up();
    session.dispose();
  });
}
