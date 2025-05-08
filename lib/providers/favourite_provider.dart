import 'package:flutter/foundation.dart';
import 'package:ilearn_papiamento/Services/favourite_services.dart';
import 'package:ilearn_papiamento/models/data_model.dart';

/// A ChangeNotifier provider for favorite words.
class FavoritesProvider extends ChangeNotifier {
  /// Internal cache of favorite Word objects.
  List<Word> _favorites = [];

  List<Word> get favorites => List.unmodifiable(_favorites);

  FavoritesProvider() {
    _loadFavorites();
  }

  /// Load all favorites from SharedPreferences.
  Future<void> _loadFavorites() async {
    _favorites = await FavoritesService.getAll();
    notifyListeners();
  }

  /// Check if a word is favorite.
  bool isFavorite(String id) {
    return _favorites.any((w) => w.learnContentsId == id);
  }

  /// Toggle favorite status and update provider state.
  Future<void> toggleFavorite(Word word) async {
    await FavoritesService.toggle(word);
    if (isFavorite(word.learnContentsId!)) {
      _favorites.add(word);
      _loadFavorites();
    } else {
      _favorites.removeWhere((w) => w.learnContentsId == word.learnContentsId);
      _loadFavorites();
    }
    notifyListeners();
  }

  /// Manually refresh the list (if needed).
  Future<void> refresh() async {
    await _loadFavorites();
  }
}
