import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ilearn_papiamento/models/data_model.dart';
import 'package:ilearn_papiamento/providers/app_settings_provider.dart';
import 'package:ilearn_papiamento/providers/audio_provider.dart';
import 'package:ilearn_papiamento/providers/favourite_provider.dart';
import 'package:ilearn_papiamento/widgets/words_tile.dart';
import 'package:provider/provider.dart';

/// Screen displaying the list of favorite words.
class FavoritesScreen extends StatefulWidget {
  final Datum category;
  final int color;
  const FavoritesScreen({
    super.key,
    required this.category,
    required this.color,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          _subTitleFor(widget.category, context),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(widget.color),
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favProv, child) {
          final favs = favProv.favorites;
          if (favs.isEmpty) {
            return Center(
              child: Text(
                appLocalizations.nofavourites,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            );
          }
          return Column(
            children: [
              Container(
                width: double.infinity,
                color: const Color(0xFF434343),
                padding: const EdgeInsets.all(16),
                child: Text(
                  _subTitleFor(widget.category, context),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: favs.length,
                  itemBuilder: (context, index) {
                    final Word word = favs[index];
                    final isExpanded = _expandedIndex == index;
                    final speed =
                        context.watch<AppSettingsProvider>().speedValue;
                    final autoPlay =
                        context.watch<AppSettingsProvider>().isVoiceAuto;

                    // Display the appropriate localized text if available
                    return CustomLearnTile(
                      isDictionary: false,
                      isFav: context.read<FavoritesProvider>().isFavorite(
                        word.learnContentsId!,
                      ),
                      color: Color(widget.color),
                      word: word,
                      isExpanded: isExpanded,
                      voiceSpeed: speed,
                      onTileTap: () async {
                        setState(
                          () => _expandedIndex = isExpanded ? null : index,
                        );
                        if (autoPlay && !isExpanded) {
                          try {
                            await context.read<AudioProvider>().play(
                              word.audioFile!,
                              speed,
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _subTitleFor(Datum cat, BuildContext ctx) {
    final lang = Localizations.localeOf(ctx).languageCode;
    return {
          'en': cat.categoryEng,
          'es': cat.categorySpan,
          'nl': cat.categoryDutch,
          'zh': cat.categoryChine,
        }[lang] ??
        cat.categoryEng ??
        '';
  }
}
