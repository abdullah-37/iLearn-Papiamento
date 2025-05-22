// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final bool isDictionary;

  const CustomLearnTile({
    super.key,
    required this.color,
    required this.word,
    required this.isExpanded,
    required this.onTileTap,
    required this.voiceSpeed,
    required this.isFav,
    required this.isDictionary,
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
              return GestureDetector(
                onTap: () => favProv.toggleFavorite(word),
                child: Icon(
                  isFav ? FontAwesomeIcons.solidStar : FontAwesomeIcons.star,
                  color: isFav ? Colors.yellow : Colors.grey,
                  size: 35,
                ),
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
                            ActionIcon(
                              image: AppImages.imgcopy,
                              onTap: () {
                                _showCopyDialog(context, color, text);
                              },
                            ),
                            ActionIcon(image: AppImages.btnfb, onTap: () {}),
                            ActionIcon(
                              image: AppImages.btntwitter,
                              onTap: () {},
                            ),
                            ActionIcon(
                              image: AppImages.btnspeaker,
                              onTap: () async {
                                if (isDictionary) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Voices are not available for Dictionary",
                                      ),
                                    ),
                                  );
                                } else {
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

  void _showCopyDialog(BuildContext context, Color color, String text) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            // backgroundColor: color,
            title: const Text(
              'Select text to copy',
              style: TextStyle(color: Colors.black),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCopyTile(
                  context,
                  word.papiamento!,
                  color,
                  // "_text1 dnj urfruhf rfur fruf r friuf rgfg r fr fr frg fr ffgryfr frf rfr gf yrgfy fry fg",
                ),
                const SizedBox(height: 12),
                _buildCopyTile(context, text, color),
              ],
            ),
            // actions: [
            //   TextButton(
            //     onPressed: () => Navigator.of(context).pop(),
            //     child: const Text('Close'),
            //   ),
            // ],
          ),
    );
  }

  Widget _buildCopyTile(BuildContext context, String text, Color color) {
    return InkWell(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: text));
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Text Copied')));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 19, color: Colors.white),
        ),
      ),
    );
  }
}
