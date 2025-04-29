import 'package:flutter/material.dart';

class HomeGridWidget extends StatelessWidget {
  const HomeGridWidget({super.key, required this.tile, required this.name});

  final Map<String, dynamic> tile;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(tile['color']),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(tile['icon'], height: 30),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
