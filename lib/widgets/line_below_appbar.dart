import 'package:flutter/material.dart';

class LineBelowAppBar extends StatelessWidget {
  const LineBelowAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Colors.white, Colors.black],
        ),
      ),
    );
  }
}
