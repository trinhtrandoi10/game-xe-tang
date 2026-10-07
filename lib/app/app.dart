import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../features/garage/garage_screen.dart';
import '../features/main_menu/main_menu_screen.dart';
import '../features/mission_result/mission_result_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/scene_spike/scene_spike_screen.dart';
import '../features/shop/shop_screen.dart';
import '../game/application/game_session.dart';
import '../game/domain/economy/economy.dart';
import '../game/domain/save/save_game.dart';
import '../game/infrastructure/persistence/local_save_repository.dart';
import '../game/presentation/game_screen.dart';
import 'localization.dart';
import 'theme.dart';

enum AppPage { menu, mission, result, garage, shop, settings, sceneSpike }

class IronGorgeApp extends StatefulWidget {
  const IronGorgeApp({super.key});

  @override
  State<IronGorgeApp> createState() => _IronGorgeAppState();
}

class _IronGorgeAppState extends State<IronGorgeApp> {
  final LocalSaveRepository _saveRepository = LocalSaveRepository();
  late Locale _deviceLocale;
  GameProfile _profile = GameProfile.newGame();
  GameSession? _session;
  AppPage _page = AppPage.menu;
  bool _loading = true;
  bool _hasSave = false;
  String? _shopFeedback;

  @override
  void initState() {
    super.initState();
    _deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    _loadSave();
  }

  @override
  void dispose() {
    _session?.dispose();
    super.dispose();
  }

  Future<void> _loadSave() async {
    try {
      final save = await _saveRepository.loadLatest();
      if (save != null) {
        _profile = save.profile;
        _hasSave = true;
      }
    } on Object {
      _profile = GameProfile.newGame();
      _hasSave = false;
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _persist() async {
    try {
      await _saveRepository.saveAtomic(SaveGame.create(_profile));
      _hasSave = true;
    } on Object {
      // The campaign remains playable if storage is temporarily unavailable.
    }
  }

  void _createSession({required bool fresh}) {
    _session?.dispose();
    if (fresh) {
      _profile.missionStage = 'reachTown';
      _profile.captureProgress = 0;
      _profile.defendRemaining = 45;
      _profile.destroyedScouts = 0;
      // A completed campaign may be replayed, but its one-time reward remains idempotent.
    }
    final session = GameSession(_profile);
    session.addListener(_onSessionChanged);
    _session = session;
    _page = AppPage.mission;
    _shopFeedback = null;
    session.start();
    _persist();
    setState(() {});
  }

  void _onSessionChanged() {
    final session = _session;
    if (session == null) return;
    if (session.consumeSaveRequest()) _persist();
  }

  void _exitMission() {
    _session?.removeListener(_onSessionChanged);
    _session?.dispose();
    _session = null;
    _page = AppPage.menu;
    _persist();
    setState(() {});
  }

  void _showResult() {
    if (_session == null) return;
    _page = AppPage.result;
    _persist();
    setState(() {});
  }

  void _goGarage() {
    _session?.removeListener(_onSessionChanged);
    _session?.dispose();
    _session = null;
    _page = AppPage.garage;
    _persist();
    setState(() {});
  }

  void _goMenu() {
    _session?.removeListener(_onSessionChanged);
    _session?.dispose();
    _session = null;
    _page = AppPage.menu;
    _persist();
    setState(() {});
  }

  void _buy(CatalogProduct product) {
    final result = buyProduct(
      inventory: _profile.inventory,
      product: product,
      parts: _profile.parts,
    );
    if (result.success) _profile.parts -= product.priceParts;
    final locale = resolveGameLocale(_deviceLocale, _profile.localePreference);
    _shopFeedback = AppStrings(locale).text(result.messageKey);
    if (result.success) _persist();
    setState(() {});
  }

  void _changeLocale(LocalePreference preference) {
    _profile.localePreference = preference;
    _persist();
    setState(() {});
  }

  void _changeCameraShake(bool value) {
    _profile.cameraShake = value;
    _persist();
    setState(() {});
  }

  Future<void> _resetProgress() async {
    final locale = resolveGameLocale(_deviceLocale, _profile.localePreference);
    final strings = AppStrings(locale);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: IronGorgeColors.panel,
          title: Text(
            strings.text('confirmReset'),
            style: const TextStyle(
              color: IronGorgeColors.amber,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Text(
            strings.text('resetWarning'),
            style: const TextStyle(color: IronGorgeColors.muted),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(strings.text('cancel')),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                strings.text('reset'),
                style: const TextStyle(color: IronGorgeColors.red),
              ),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) return;
    _profile = GameProfile.newGame();
    _hasSave = false;
    _page = AppPage.menu;
    await _persist();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final locale = resolveGameLocale(_deviceLocale, _profile.localePreference);
    final strings = AppStrings(locale);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: strings.appTitle,
      theme: buildIronGorgeTheme(),
      locale: locale,
      supportedLocales: const <Locale>[Locale('vi'), Locale('en')],
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: _loading ? _BootScreen(strings: strings) : _buildPage(strings),
    );
  }

  Widget _buildPage(AppStrings strings) {
    switch (_page) {
      case AppPage.menu:
        return MainMenuScreen(
          strings: strings,
          profile: _profile,
          hasSave: _hasSave,
          onContinue: () => _createSession(fresh: false),
          onNewMission: () => _createSession(fresh: true),
          onGarage: _goGarage,
          onShop: () {
            _page = AppPage.shop;
            _shopFeedback = null;
            setState(() {});
          },
          onSettings: () {
            _page = AppPage.settings;
            setState(() {});
          },
        );
      case AppPage.mission:
        final session = _session;
        if (session == null) return _fallbackMenu(strings);
        return GameScreen(
          session: session,
          strings: strings,
          onExit: _exitMission,
          onResult: _showResult,
        );
      case AppPage.result:
        final session = _session;
        if (session == null) return _fallbackMenu(strings);
        return MissionResultScreen(
          strings: strings,
          profile: _profile,
          snapshot: session.snapshot,
          onRetry: () => _createSession(fresh: false),
          onGarage: _goGarage,
          onMenu: _goMenu,
        );
      case AppPage.garage:
        return GarageScreen(
          strings: strings,
          profile: _profile,
          onBack: _goMenu,
          onShop: () => setState(() => _page = AppPage.shop),
          onSave: _persist,
        );
      case AppPage.shop:
        return ShopScreen(
          strings: strings,
          profile: _profile,
          feedback: _shopFeedback,
          onBack: _goMenu,
          onBuy: _buy,
        );
      case AppPage.settings:
        return SettingsScreen(
          strings: strings,
          profile: _profile,
          deviceLocale: _deviceLocale,
          onBack: _goMenu,
          onLocaleChanged: _changeLocale,
          onCameraShakeChanged: _changeCameraShake,
          onSceneSpike: () => setState(() => _page = AppPage.sceneSpike),
          onReset: _resetProgress,
        );
      case AppPage.sceneSpike:
        return SceneSpikeScreen(
          strings: strings,
          onBack: () => setState(() => _page = AppPage.settings),
        );
    }
  }

  Widget _fallbackMenu(AppStrings strings) {
    return MainMenuScreen(
      strings: strings,
      profile: _profile,
      hasSave: _hasSave,
      onContinue: () => _createSession(fresh: false),
      onNewMission: () => _createSession(fresh: true),
      onGarage: _goGarage,
      onShop: () => setState(() => _page = AppPage.shop),
      onSettings: () => setState(() => _page = AppPage.settings),
    );
  }
}

class _BootScreen extends StatelessWidget {
  const _BootScreen({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const CircularProgressIndicator(color: IronGorgeColors.cyan),
            const SizedBox(height: 18),
            Text(
              strings.appTitle,
              style: const TextStyle(
                color: IronGorgeColors.text,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
