// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:ilearn_papiamento/config/app_colors.dart';
import 'package:ilearn_papiamento/config/images.dart';
import 'package:ilearn_papiamento/models/data_model.dart';
import 'package:ilearn_papiamento/providers/audio_provider.dart';
import 'package:ilearn_papiamento/providers/favourite_provider.dart';
import 'package:ilearn_papiamento/views/learn_screen.dart';
import 'package:provider/provider.dart';

/// Reusable tile for learning items
class CustomLearnTile extends StatelessWidget {
  final Color color;
  final Word word;
  final bool isExpanded;
  final VoidCallback onTileTap;
  final double voiceSpeed;
  final bool isFav;

  const CustomLearnTile({
    super.key,
    required this.color,
    required this.word,
    required this.isExpanded,
    required this.onTileTap,
    required this.voiceSpeed,
    required this.isFav,
  });

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final text =
        {
          'en': word.english,
          'es': word.spanish,
          'nl': word.dutch,
          'zh': word.chinese,
        }[lang] ??
        word.papiamento ??
        '';

    return Column(
      children: [
        ListTile(
          splashColor: color.withOpacity(0.3),
          trailing: Consumer<FavoritesProvider>(
            builder: (context, favProv, child) {
              final isFav = favProv.isFavorite(word.learnContentsId!);
              return IconButton(
                icon: Icon(
                  isFav ? FontAwesomeIcons.solidStar : FontAwesomeIcons.star,
                  color: isFav ? Colors.yellow : Colors.grey,
                ),
                iconSize: 28,
                onPressed: () => favProv.toggleFavorite(word),
              );
            },
          ),

          onTap: onTileTap,
          // titleTextStyle: const TextStyle(fontSize: 17),
          title: Text(
            // 'ss sushf fdhfdj fdfd jfdjfd  d fdjfd f dfd fd fdfd fdf df dfu ',
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child:
              isExpanded
                  ? Container(
                    width: double.infinity,
                    color: AppColors.learnTileopenedbg,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // 'nefh efheuf eifhefi efehfeifh f ef efi ff fhef efe ff fhefheufhef ef efeu fehfeiuh ',
                          word.papiamento ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ActionIcon(image: AppImages.imgcopy, onTap: () {}),
                            ActionIcon(image: AppImages.btnfb, onTap: () {}),
                            ActionIcon(
                              image: AppImages.btntwitter,
                              onTap: () {},
                            ),
                            ActionIcon(
                              image: AppImages.btnspeaker,
                              onTap: () async {
                                try {
                                  await context.read<AudioProvider>().play(
                                    word.audioFile!,
                                    voiceSpeed,
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                  : const SizedBox.shrink(),
        ),
        if (!isExpanded)
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, color, Colors.black],
              ),
            ),
          ),
      ],
    );
  }
}
