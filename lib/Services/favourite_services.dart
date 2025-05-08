import 'dart:convert';

import 'package:ilearn_papiamento/models/data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simplified service to manage favorite words in SharedPreferences.
class FavoritesService {
  static const _key = 'favorite_words';

  /// Add a word to favorites (avoiding duplicates).
  static Future<void> add(Word word) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    if (!list.any(
      (item) => json.decode(item)['learnContentsID'] == word.learnContentsId,
    )) {
      list.add(json.encode(word.toJson()));
      await prefs.setStringList(_key, list);
    }
  }

  /// Remove a word from favorites by ID.
  static Future<void> remove(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    list.removeWhere((item) => json.decode(item)['learnContentsID'] == id);
    await prefs.setStringList(_key, list);
  }

  /// Toggle favorite status: add if not present, remove if present.
  static Future<void> toggle(Word word) async {
    if (await isFavorite(word.learnContentsId!)) {
      await remove(word.learnContentsId!);
    } else {
      await add(word);
    }
  }

  /// Check if a word is favorite by ID.
  static Future<bool> isFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.any((item) => json.decode(item)['learnContentsID'] == id);
  }

  /// Retrieve all favorite words.
  static Future<List<Word>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list
        .map((item) {
          try {
            return Word.fromJson(json.decode(item));
          } catch (_) {
            return null;
          }
        })
        .whereType<Word>()
        .toList();
  }
}
