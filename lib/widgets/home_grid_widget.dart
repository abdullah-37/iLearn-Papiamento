import 'package:flutter/material.dart';
import 'package:ilearn_papiamento/models/data_model.dart';

class HomeGridWidget extends StatelessWidget {
  final Datum category;

  const HomeGridWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    String name;
    switch (lang) {
      case 'en':
        name = category.categoryEng ?? '';
        break;
      case 'es':
        name = category.categorySpan ?? '';
        break;
      case 'nl':
        name = category.categoryDutch ?? '';
        break;
      case 'zh':
        name = category.categoryChine ?? '';
      default:
        name = category.categoryEng ?? '';
    }
    final color = Color(int.parse("FF${category.color}", radix: 16));
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/imganimals.png', height: 30),
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
