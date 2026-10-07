import 'package:flutter/material.dart';

import '../../app/localization.dart';
import '../../app/theme.dart';
import '../../game/domain/save/save_game.dart';
import '../../shared/widgets/iron_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.strings,
    required this.profile,
    required this.deviceLocale,
    required this.onBack,
    required this.onLocaleChanged,
    required this.onCameraShakeChanged,
    required this.onSceneSpike,
    required this.onReset,
  });

  final AppStrings strings;
  final GameProfile profile;
  final Locale deviceLocale;
  final VoidCallback onBack;
  final ValueChanged<LocalePreference> onLocaleChanged;
  final ValueChanged<bool> onCameraShakeChanged;
  final VoidCallback onSceneSpike;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: onBack,
                        icon: const Icon(
                          Icons.arrow_back,
                          color: IronGorgeColors.cyan,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        strings.text('settings'),
                        style: const TextStyle(
                          color: IronGorgeColors.text,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  GorgePanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          strings.text('language'),
                          style: const TextStyle(
                            color: IronGorgeColors.cyan,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.8,
                          ),
                        ),
                        const SizedBox(height: 13),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: <Widget>[
                            _Option(
                              label: strings.text('deviceLanguage'),
                              selected:
                                  profile.localePreference ==
                                  LocalePreference.device,
                              onTap: () =>
                                  onLocaleChanged(LocalePreference.device),
                            ),
                            _Option(
                              label: strings.text('vietnamese'),
                              selected:
                                  profile.localePreference ==
                                  LocalePreference.vi,
                              onTap: () => onLocaleChanged(LocalePreference.vi),
                            ),
                            _Option(
                              label: strings.text('english'),
                              selected:
                                  profile.localePreference ==
                                  LocalePreference.en,
                              onTap: () => onLocaleChanged(LocalePreference.en),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'DEVICE // ${deviceLocale.languageCode.toUpperCase()}',
                          style: const TextStyle(
                            color: IronGorgeColors.muted,
                            fontSize: 10,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  GorgePanel(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(
                            Icons.vibration,
                            color: IronGorgeColors.amber,
                          ),
                          title: Text(
                            strings.text('cameraShake'),
                            style: const TextStyle(
                              color: IronGorgeColors.text,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                          subtitle: Text(
                            profile.cameraShake
                                ? strings.text('on')
                                : strings.text('off'),
                            style: const TextStyle(
                              color: IronGorgeColors.muted,
                              fontSize: 10,
                            ),
                          ),
                          trailing: Switch(
                            value: profile.cameraShake,
                            onChanged: onCameraShakeChanged,
                            activeThumbColor: IronGorgeColors.cyan,
                          ),
                        ),
                        const Divider(height: 1, color: IronGorgeColors.line),
                        ListTile(
                          leading: const Icon(
                            Icons.sd_storage_outlined,
                            color: IronGorgeColors.cyan,
                          ),
                          title: Text(
                            strings.text('saveStatus'),
                            style: const TextStyle(
                              color: IronGorgeColors.text,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                          subtitle: const Text(
                            'SCHEMA 1 // CHECKSUMMED // BACKUP ENABLED',
                            style: TextStyle(
                              color: IronGorgeColors.muted,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const Divider(height: 1, color: IronGorgeColors.line),
                        ListTile(
                          onTap: onSceneSpike,
                          leading: const Icon(
                            Icons.view_in_ar_outlined,
                            color: IronGorgeColors.amber,
                          ),
                          title: Text(
                            strings.text('sceneSpike'),
                            style: const TextStyle(
                              color: IronGorgeColors.text,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                          subtitle: Text(
                            strings.text('sceneSpikeDescription'),
                            style: const TextStyle(
                              color: IronGorgeColors.muted,
                              fontSize: 10,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: IronGorgeColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IronButton(
                    label: strings.text('reset'),
                    onPressed: onReset,
                    danger: true,
                    icon: Icons.delete_outline,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: selected
              ? IronGorgeColors.cyan.withAlpha(28)
              : Colors.transparent,
          border: Border.all(
            color: selected ? IronGorgeColors.cyan : IronGorgeColors.line,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? IronGorgeColors.cyan : IronGorgeColors.muted,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
          ),
        ),
      ),
    );
  }
}
