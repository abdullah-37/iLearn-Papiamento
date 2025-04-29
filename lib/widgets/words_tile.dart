import 'package:flutter/material.dart';
import 'package:ilearn_papiamento/data_loader.dart';

class PhraseTile extends StatefulWidget {
  final Color color;
  final Phrase phrase;
  const PhraseTile({super.key, required this.color, required this.phrase});

  @override
  State<PhraseTile> createState() => _PhraseTileState();
}

class _PhraseTileState extends State<PhraseTile> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => expanded = !expanded),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.phrase.sourceText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (expanded) ...[
              const SizedBox(height: 8),
              Text(
                widget.phrase.papiamento,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
