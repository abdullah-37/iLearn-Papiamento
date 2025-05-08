import 'package:flutter/material.dart';
import 'package:ilearn_papiamento/Services/audio_service.dart';

class AudioProvider extends ChangeNotifier {
  final AudioService _audioService;

  AudioProvider(this._audioService);

  Future<void> play(String audioFile, double speed) async {
    try {
      await _audioService.playCached(audioFile, speed);
    } catch (e) {
      notifyListeners();
      throw ' Some Thing wrong';
    }
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
