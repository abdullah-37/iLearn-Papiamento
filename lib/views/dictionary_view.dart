import 'package:flutter/material.dart';
import 'package:ilearn_papiamento/config/app_colors.dart';
import 'package:ilearn_papiamento/providers/app_settings_provider.dart';
import 'package:ilearn_papiamento/providers/audio_provider.dart';
import 'package:ilearn_papiamento/providers/dictionary_provider.dart';
import 'package:ilearn_papiamento/providers/favourite_provider.dart';
import 'package:ilearn_papiamento/widgets/words_tile.dart';
import 'package:provider/provider.dart';

class DictionaryPage extends StatefulWidget {
  final Color color;
  const DictionaryPage({super.key, required this.color});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    // 3️⃣ Use .value so it doesn’t try to recreate it
    final lang = context.read<AppSettingsProvider>().locale.languageCode;
    context.read<DictionaryProvider>().setSelectedLanguage(lang);

    return Scaffold(
      backgroundColor: AppColors.appBg,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Papiamento Dictionary',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: widget.color,
      ),
      body: Consumer<DictionaryProvider>(
        builder: (context, prov, _) {
          if (prov.words.isEmpty && prov.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
          return Column(
            children: [
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  onChanged: prov.search,

                  style: const TextStyle(
                    color: Color.fromARGB(255, 64, 64, 64),
                  ),
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 228, 228, 228),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              //Search Bar
              Expanded(
                child: ListView.builder(
                  // controller: _controller,
                  itemCount:
                      prov.searchResults.length + (prov.isLoading ? 1 : 0),
                  // separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, idx) {
                    if (idx < prov.searchResults.length) {
                      final words = prov.searchResults[idx];
                      final isExpanded = _expandedIndex == idx;
                      final speed =
                          context.watch<AppSettingsProvider>().speedValue;
                      final autoPlay =
                          context.watch<AppSettingsProvider>().isVoiceAuto;

                      return CustomLearnTile(
                        isDictionary: true,
                        isFav: context.read<FavoritesProvider>().isFavorite(
                          words.learnContentsId!,
                        ),
                        // color: Color(int.parse("FF${cat.color}", radix: 16)),
                        color: widget.color,
                        word: words,
                        isExpanded: isExpanded,
                        voiceSpeed: speed,
                        onTileTap: () async {
                          setState(
                            () => _expandedIndex = isExpanded ? null : idx,
                          );
                          if (autoPlay && !isExpanded) {
                            // try {
                            //   // await context.read<AudioProvider>().play(
                            //   //   words.audioFile!,
                            //   //   speed,
                            //   // );
                            // } catch (e) {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     SnackBar(content: Text(e.toString())),
                            //   );
                            // }
                          }
                        },
                      );
                    }
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
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
}
