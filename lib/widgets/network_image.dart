import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ilearn_papiamento/config/config.dart';

class CustomNetworkImageWidget extends StatelessWidget {
  const CustomNetworkImageWidget({
    super.key,
    required this.imagePath,
    this.imageHeight,
    this.imageWidth,
  });

  final String imagePath;

  final double? imageHeight;
  final double? imageWidth;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: '${AppConfig.imagesUrl}$imagePath',
      height: imageHeight,
      width: imageWidth,

      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}


//  Image.network(
//       '${AppConfig.imagesUrl}$imagePath',
//       fit: BoxFit.contain,
//       width: imageWidth,
//       height: imageHeight,
//       errorBuilder: (context, error, stackTrace) {
//         return const Icon(Icons.broken_image, size: 30, color: Colors.grey);
//       },
//     );