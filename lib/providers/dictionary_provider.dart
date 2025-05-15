import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ilearn_papiamento/config/config.dart';
import 'package:ilearn_papiamento/models/data_model.dart';
import 'package:ilearn_papiamento/models/dictionary_data_model.dart';

class DictionaryProvider with ChangeNotifier {
  final Dio _dio;

  final int _paginateCount = 20; // items per page
  final int _pageIndex = 1; // start at page=1
  bool _isLoading = false;

  final List<Word> _words = [];
  List<Word> get words => List.unmodifiable(_words);
  final List<Word> _searchResults = [];
  List<Word> get searchResults => List.unmodifiable(_searchResults);
  bool get isLoading => _isLoading;
  String _lastQuery = '';

  DictionaryProvider()
    : _dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.baseUrl,
          headers: {
            "Authorization":
                "Basic ${base64Encode(utf8.encode("${AppConfig.adminUserName}:${AppConfig.adminPassword}"))}",
          },
        ),
      ) {
    fetchNextPage();
  }

  Future<void> fetchNextPage() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();
    try {
      print('-----------------------------------$_pageIndex');
      final resp = await _dio.get(
        AppConfig.dictioanyWordsUrl,
        // queryParameters: {'paginate': _paginateCount, 'page': _pageIndex},
      );
      if (resp.statusCode == 200 && resp.data != null) {
        final model = DictionaryDataModel.fromJson(resp.data);
        final batch = model.dictionaryWords ?? [];
        _words.addAll(batch);
        _updateSearchResults();
      } else {
        debugPrint('Dictionary load failed (status ${resp.statusCode})');
      }
    } catch (e) {
      debugPrint('Error loading page $_pageIndex: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    _lastQuery = query.trim().toLowerCase();
    _updateSearchResults();
    notifyListeners();
  }

  /// Updates searchResults based on lastQuery
  void _updateSearchResults() {
    _searchResults.clear();
    if (_lastQuery.isEmpty) {
      _searchResults.addAll(_words);
    } else {
      _searchResults.addAll(
        _words.where(
          (w) => w.papiamento?.toLowerCase().contains(_lastQuery) ?? false,
        ),
      );
    }
  }
}
