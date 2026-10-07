import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/save/save_game.dart';

class LocalSaveRepository implements SaveGameRepository {
  static const _primaryKey = 'iron_gorge.save.primary';
  static const _backupKey = 'iron_gorge.save.backup';

  @override
  Future<SaveGame?> loadLatest() async {
    final preferences = await SharedPreferences.getInstance();
    final primary = _decode(preferences.getString(_primaryKey));
    if (primary != null) return primary;
    return _decode(preferences.getString(_backupKey));
  }

  @override
  Future<void> saveAtomic(SaveGame save) async {
    final preferences = await SharedPreferences.getInstance();
    final current = preferences.getString(_primaryKey);
    if (current != null) await preferences.setString(_backupKey, current);
    await preferences.setString(_primaryKey, jsonEncode(save.toJson()));
  }

  SaveGame? _decode(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      return SaveGame.fromJson(Map<String, dynamic>.from(decoded));
    } on Object {
      return null;
    }
  }
}
