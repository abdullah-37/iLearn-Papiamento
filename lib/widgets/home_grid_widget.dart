import 'package:flutter/material.dart';
import 'package:ilearn_papiamento/widgets/network_image.dart';

class HomeGridWidget extends StatelessWidget {
  final dynamic category;

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
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(child: CustomNetworkImageWidget(imagePath: category.image!)),
          const SizedBox(height: 8),
          Text(
            // 'sdsds sdsd d',
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              // fontFamily: AppConfig.avenir,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
