// lib/providers/fetch_data_provider.dart
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ilearn_papiamento/Services/api_services.dart';
import 'package:ilearn_papiamento/Services/audio_cache_service.dart';
import 'package:ilearn_papiamento/models/data_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FetchDataProvider extends ChangeNotifier {
  final ApiServices apiServices = ApiServices();
  final AudioCacheService audioCache;
  final AudioPlayer _audioPlayer = AudioPlayer();

  CategoriesDataModel? categoriesData;
  bool isLoading = false;

  // --- Audio playback state ---
  String? _currentFile;
  final bool _isLoadingAudio = false;
  String? _audioError;

  String? get currentFile => _currentFile;
  bool get isLoadingAudio => _isLoadingAudio;
  String? get audioError => _audioError;
  PlayerState get playerState => _audioPlayer.playerState;

  FetchDataProvider({required String audioBaseUrl})
    : audioCache = AudioCacheService(baseUrl: audioBaseUrl) {
    fetchCategories();
  }
  Future<bool> _hasInternet({int timeoutSeconds = 3}) async {
    try {
      final uri = Uri.https('www.google.com', '/');
      final resp = await http
          .head(uri)
          .timeout(Duration(seconds: timeoutSeconds));
      return resp.statusCode == HttpStatus.ok ||
          resp.statusCode == HttpStatus.found;
    } catch (_) {
      return false;
    }
  }

  Future<void> fetchCategories() async {
    isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    try {
      final online = await _hasInternet();

      if (online) {
        debugPrint('✅ Internet reachable — fetching from API');
        final res = await apiServices.fetchData();
        if (res.success == true) {
          categoriesData = res;
          final jsonStr = CategoriesDataModelToJson(res);
          await prefs.setString('categories_json', jsonStr);
          debugPrint('Fetched and cached categories');
        } else {
          debugPrint('API returned success=false; falling back to cache');
          await _loadFromCache(prefs);
        }
      } else {
        debugPrint('⚠️ No internet — loading from cache');
        await _loadFromCache(prefs);
      }
    } catch (e) {
      debugPrint('fetchCategories error: $e — loading from cache');
      await _loadFromCache(prefs);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadFromCache(SharedPreferences prefs) async {
    if (prefs.containsKey('categories_json')) {
      final jsonStr = prefs.getString('categories_json')!;
      categoriesData = CategoriesDataModelFromJson(jsonStr);
      debugPrint('Loaded categories from cache');
    } else {
      debugPrint('No cached categories found');
      categoriesData = null;
    }
  }
}
