import 'package:flutter/material.dart';
import 'package:ilearn_papiamento/Services/audio_service.dart';

class AudioProvider extends ChangeNotifier {
  final AudioService _audioService;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  AudioProvider(this._audioService);

  Future<void> play(String audioFile, double speed) async {
    if (_isPlaying) {
      // Already playing—ignore or throw if you want
      throw 'Voice Already in Process';
    }

    _isPlaying = true;
    notifyListeners();

    try {
      // Assume playCached completes when playback ends
      await _audioService.playCached(audioFile, speed);
    } catch (e) {
      debugPrint('Audio play error: $e');
      // You might rethrow or handle the error differently
      throw 'Something went wrong while playing audio';
    } finally {
      // Always reset playing state
      _isPlaying = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
