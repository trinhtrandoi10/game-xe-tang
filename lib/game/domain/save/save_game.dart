import 'dart:convert';

enum LocalePreference { device, vi, en }

class GameProfile {
  GameProfile({
    required this.parts,
    required this.aresData,
    required this.titan,
    required this.missionStage,
    required this.captureProgress,
    required this.defendRemaining,
    required this.destroyedScouts,
    required this.rewardClaimed,
    required this.inventory,
    required this.equippedSkin,
    required this.localePreference,
    required this.cameraShake,
  });

  factory GameProfile.newGame() {
    return GameProfile(
      parts: 600,
      aresData: 0,
      titan: 0,
      missionStage: 'reachTown',
      captureProgress: 0,
      defendRemaining: 45,
      destroyedScouts: 0,
      rewardClaimed: false,
      inventory: <String, int>{'field_repair_kit': 1},
      equippedSkin: 'steel_storm',
      localePreference: LocalePreference.device,
      cameraShake: true,
    );
  }

  int parts;
  int aresData;
  int titan;
  String missionStage;
  double captureProgress;
  double defendRemaining;
  int destroyedScouts;
  bool rewardClaimed;
  Map<String, int> inventory;
  String equippedSkin;
  LocalePreference localePreference;
  bool cameraShake;

  int owned(String itemId) => inventory[itemId] ?? 0;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'parts': parts,
      'aresData': aresData,
      'titan': titan,
      'missionStage': missionStage,
      'captureProgress': captureProgress,
      'defendRemaining': defendRemaining,
      'destroyedScouts': destroyedScouts,
      'rewardClaimed': rewardClaimed,
      'inventory': inventory,
      'equippedSkin': equippedSkin,
      'localePreference': localePreference.name,
      'cameraShake': cameraShake,
    };
  }

  factory GameProfile.fromJson(Map<String, dynamic> json) {
    final rawInventory = json['inventory'];
    final inventory = <String, int>{};
    if (rawInventory is Map) {
      rawInventory.forEach((key, value) {
        if (key is String && value is num) inventory[key] = value.toInt();
      });
    }
    return GameProfile(
      parts: _intValue(json['parts'], 600),
      aresData: _intValue(json['aresData'], 0),
      titan: _intValue(json['titan'], 0),
      missionStage: json['missionStage'] is String
          ? json['missionStage'] as String
          : 'reachTown',
      captureProgress: _doubleValue(json['captureProgress'], 0),
      defendRemaining: _doubleValue(json['defendRemaining'], 45),
      destroyedScouts: _intValue(json['destroyedScouts'], 0),
      rewardClaimed: json['rewardClaimed'] == true,
      inventory: inventory,
      equippedSkin: json['equippedSkin'] is String
          ? json['equippedSkin'] as String
          : 'steel_storm',
      localePreference: LocalePreference.values.firstWhere(
        (value) => value.name == json['localePreference'],
        orElse: () => LocalePreference.device,
      ),
      cameraShake: json['cameraShake'] != false,
    );
  }

  GameProfile copy() {
    return GameProfile.fromJson(toJson());
  }
}

class SaveGame {
  const SaveGame({
    required this.profile,
    required this.savedAt,
    required this.schemaVersion,
    required this.checksum,
  });

  static const currentSchemaVersion = 1;

  final GameProfile profile;
  final DateTime savedAt;
  final int schemaVersion;
  final String checksum;

  factory SaveGame.create(GameProfile profile, {DateTime? now}) {
    final profileJson = jsonEncode(profile.toJson());
    return SaveGame(
      profile: profile.copy(),
      savedAt: now ?? DateTime.now().toUtc(),
      schemaVersion: currentSchemaVersion,
      checksum: _checksum(profileJson),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'schemaVersion': schemaVersion,
      'savedAt': savedAt.toIso8601String(),
      'checksum': checksum,
      'profile': profile.toJson(),
    };
  }

  factory SaveGame.fromJson(Map<String, dynamic> json) {
    final schemaVersion = _intValue(json['schemaVersion'], 0);
    if (schemaVersion != currentSchemaVersion) {
      throw FormatException('Unsupported save schema: $schemaVersion');
    }
    final rawProfile = json['profile'];
    if (rawProfile is! Map) {
      throw const FormatException('Save profile is missing');
    }
    final profile = GameProfile.fromJson(Map<String, dynamic>.from(rawProfile));
    final expected = _checksum(jsonEncode(profile.toJson()));
    if (json['checksum'] != expected) {
      throw const FormatException('Save checksum mismatch');
    }
    final savedAt = DateTime.tryParse(json['savedAt'] as String? ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
    return SaveGame(
      profile: profile,
      savedAt: savedAt,
      schemaVersion: schemaVersion,
      checksum: expected,
    );
  }

  static String _checksum(String value) {
    var hash = 2166136261;
    for (final codeUnit in value.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * 16777619) & 0xFFFFFFFF;
    }
    return hash.toRadixString(16).padLeft(8, '0');
  }
}

int _intValue(Object? value, int fallback) =>
    value is num ? value.toInt() : fallback;

double _doubleValue(Object? value, double fallback) =>
    value is num ? value.toDouble() : fallback;

abstract interface class SaveGameRepository {
  Future<SaveGame?> loadLatest();

  Future<void> saveAtomic(SaveGame save);
}
