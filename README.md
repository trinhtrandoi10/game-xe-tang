# IRON GORGE: ARES OVERRIDE

Playable MVP spike for **KHE SẮT: CHỈ THỊ ZERO**, built from the supplied implementation plans.

## What is implemented

- Flutter shell with Vietnamese/English localization and device-language selection.
- Offline campaign loop: reach Binh Minh → destroy ARES scouts → capture and defend Nam-1 radar.
- Canvas battlefield renderer with tank, turret, projectile tracer, minimap, landmarks and impact effects.
- Touch controls: left joystick, right-side turret aim, fire, AP/HE switch, target lock and field repair.
- Vehicle movement, reload/ammo state, AP/HE armor resolution, module damage and two enemy archetypes with patrol/flank/fire behavior.
- Main menu, mission result, garage, Parts shop, settings, pause/retry and local save.
- Versioned save payload with checksum and primary/backup persistence through `shared_preferences`.
- Engine-agnostic renderer, physics and commerce ports; procedural `flutter_scene` 3D adapter spike is available from Settings.

## Run

```bash
flutter pub get
flutter test
flutter run -d <android-device-id>
```

For Android:

```bash
flutter build apk --debug
```

For iOS, run on macOS with Xcode:

```bash
flutter build ios --no-codesign
```

The project targets Android and iOS only. Flutter 3.47.4 now satisfies the plan baseline and the `flutter_scene`/Rapier dependencies are present. Flutter GPU is enabled in the Android manifest and iOS plist. The current playable slice keeps Canvas as a stable fallback renderer while the concrete 3D adapter is validated on physical Android/iOS hardware; gameplay remains engine-agnostic through the scene/physics ports.
