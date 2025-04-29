import 'package:flutter/material.dart';
import 'package:ilearn_papiamento/data_loader.dart';
import 'package:ilearn_papiamento/localization_provider.dart';
import 'package:provider/provider.dart';

class LearnScreen extends StatelessWidget {
  final Color color;
  final String moduleKey;
  // remove defaultTitle entirely

  const LearnScreen({super.key, required this.color, required this.moduleKey});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<AppLanguage>().locale.languageCode;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: color,

        // ← replace the fixed Text(defaultTitle) with this:
        title: FutureBuilder<String>(
          future: DataService.loadSubcategory(moduleKey, locale),
          builder: (ctx, snap) {
            final title = snap.data ?? moduleKey;
            return Text(title, style: const TextStyle(color: Colors.white));
          },
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // your language‐picker here...
              context.read<AppLanguage>().changeLanguage(
                locale == 'en'
                    ? 'es'
                    : locale == 'es'
                    ? 'nl'
                    : locale == 'nl'
                    ? 'zh'
                    : 'en',
              );
            },
          ),
        ],
      ),

      body: FutureBuilder<List<Phrase>>(
        future: DataService.loadPhrases(moduleKey, locale),
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final phrases = snap.data!;
          return ListView(
            children:
                phrases
                    .map((p) => _PhraseTile(color: color, phrase: p))
                    .toList(),
          );
        },
      ),
    );
  }
}

class _PhraseTile extends StatefulWidget {
  final Color color;
  final Phrase phrase;
  const _PhraseTile({required this.color, required this.phrase});

  @override
  State<_PhraseTile> createState() => _PhraseTileState();
}

class _PhraseTileState extends State<_PhraseTile> {
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
