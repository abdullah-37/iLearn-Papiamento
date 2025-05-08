import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class AudioCacheService {
  final String baseUrl;
  AudioCacheService({required this.baseUrl});

  Future<File?> fetch(String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      print(dir.path);
      final file = File('${dir.path}/$fileName');

      if (await file.exists()) return file;

      final uri = Uri.parse('$baseUrl$fileName');
      final resp = await http.get(uri);

      if (resp.statusCode != 200) {
        throw Exception('Failed to download $fileName');
      }

      return await file.writeAsBytes(resp.bodyBytes);
    } catch (e) {
      debugPrint('AudioCacheService fetch error: $e');
      return null; // Return null on failure
    }
  }
}