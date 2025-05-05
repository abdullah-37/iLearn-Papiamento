// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
// import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:ilearn_papiamento/config/app_colors.dart';
import 'package:ilearn_papiamento/config/images.dart';
import 'package:ilearn_papiamento/models/data_model.dart';

class CustomLearnTile extends StatefulWidget {
  final Color color;
  final Word word;
  final bool isExpanded;
  final VoidCallback onTileTap;

  const CustomLearnTile({
    super.key,
    required this.color,
    required this.word,
    required this.isExpanded,
    required this.onTileTap,
  });

  @override
  State<CustomLearnTile> createState() => _CustomLearnTileState();
}

class _CustomLearnTileState extends State<CustomLearnTile>
    with SingleTickerProviderStateMixin {
  bool isFav = false;
  toggleFav() {
    setState(() {
      isFav = !isFav;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final text = () {
      switch (lang) {
        case 'en':
          return widget.word.english ?? '';
        case 'es':
          return widget.word.spanish ?? '';
        case 'nl':
          return widget.word.dutch ?? '';
        case 'zh':
          return widget.word.chinese ?? '';
        default:
          return widget.word.papiamento ?? '';
      }
    }();

    return Column(
      children: [
        ListTile(
          splashColor: widget.color.withOpacity(0.3),
          trailing: GestureDetector(
            onTap: () {
              toggleFav();
            },
            child: Icon(
              // Icons.star,
              isFav ? FontAwesomeIcons.solidStar : FontAwesomeIcons.star,
              color:
                  isFav ? Colors.yellow : const Color.fromARGB(255, 99, 99, 99),
              size: 30,
            ),
          ),
          onTap: widget.onTileTap,
          title: Text(text, style: const TextStyle(color: Colors.white)),
        ),

        AnimatedSize(
          duration: const Duration(milliseconds: 500),
          // curve: Curves.easeInOut,
          child:
              widget.isExpanded
                  ? Container(
                    width: double.infinity,
                    color: AppColors.learnTileopenedbg,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // shrink to fit contents
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            widget.word.papiamento ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomIcon(image: AppImages.imgcopy, onTap: () {}),

                            CustomIcon(image: AppImages.btnfb, onTap: () {}),

                            CustomIcon(
                              image: AppImages.btntwitter,
                              onTap: () {},
                            ),

                            CustomIcon(
                              image: AppImages.btnspeaker,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                  : const SizedBox.shrink(),
        ),
        if (!widget.isExpanded)
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, widget.color, Colors.black],
              ),
            ),
          ),
      ],
    );
  }
}

class CustomIcon extends StatelessWidget {
  final String image;
  final GestureTapCallback onTap;
  const CustomIcon({super.key, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Image.asset(image, height: 30));
  }
}
