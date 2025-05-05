import 'package:flutter/material.dart';

class Homescreenprovider extends ChangeNotifier {
  late final AnimationController _controller;

  Homescreenprovider(TickerProvider vsync, {int durationMs = 300}) {
    _controller = AnimationController(
      vsync: vsync,
      duration: Duration(milliseconds: durationMs),
    )..addListener(() => notifyListeners());
  }

  AnimationController get controller => _controller;
  bool get isOpen => _controller.value > 0.5;

  void toggle() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
