import 'package:flutter/material.dart';
import 'package:ilearn_papiamento/Services/audio_cache_service.dart';
import 'package:ilearn_papiamento/config/config.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playCached(String audioFile, double speed) async {
    try {
      final cache = AudioCacheService(baseUrl: AppConfig.audioBaseUrl);
      final file = await cache.fetch(audioFile);
      if (file == null)
        throw Exception('Failed to load audio file: $audioFile');

      await _player.setFilePath(file.path);
      await _player.setSpeed(speed);
      await _player.seek(Duration.zero);
      await _player.play();
    } catch (e, st) {
      debugPrint('AudioService.playCached error: $e\n$st');
      rethrow;
    }
  }

  void dispose() => _player.dispose();
}
