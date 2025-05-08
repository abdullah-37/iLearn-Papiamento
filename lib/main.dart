import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ilearn_papiamento/Services/audio_service.dart';
import 'package:ilearn_papiamento/Services/shared_prefrence.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ilearn_papiamento/config/app_colors.dart';
import 'package:ilearn_papiamento/config/config.dart';
import 'package:ilearn_papiamento/providers/ads_provider.dart';
import 'package:ilearn_papiamento/providers/app_settings_provider.dart';
import 'package:ilearn_papiamento/providers/audio_provider.dart';
import 'package:ilearn_papiamento/providers/favourite_provider.dart';
import 'package:ilearn_papiamento/providers/fetch_data_provider.dart';
import 'package:ilearn_papiamento/views/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final audioService = AudioService();
  await SharedPrefsService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdsProvider()),
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider(audioService)),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(
          create:
              (_) => FetchDataProvider(audioBaseUrl: AppConfig.audioBaseUrl),
        ),
      ],
      child: const MyApp(),
    ),
  );

  await MobileAds.instance.initialize();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final appLang = context.watch<AppSettingsProvider>();
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: AppColors.appBg),
      debugShowCheckedModeBanner: false,
      locale: appLang.locale,
      supportedLocales: const [
        Locale('en'), // Spanish
        Locale('es'), // Dutch
        Locale('nl'), // Spanish
        Locale('zh'), // Dutch
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // we don’t need arb/intl for data files, so we skip flutter_localizations here
      home: const SplashScreen(),
    );
  }
}

// import 'dart:convert';

// import 'package:flutter/services.dart';

// /// Maps locale codes to the JSON field that holds your “source” text.
// const Map<String, String> _localeField = {
//   'en': 'english',
//   'es': 'spanish',
//   'nl': 'dutch',
//   'zh': 'chinese',
// };

// class DataService {
//   /// Loads *all* JSON files under assets/data/<locale>/ and returns
//   /// a List of HomeModuleData, each containing:
//   ///  • moduleKey  ("bank", "travel", ...)
//   ///  • title      (the first "subcategory" in that JSON)
//   ///  • phrases    (List<Phrase> parsed per the chosen locale)
//   static Future<List<HomeModuleData>> loadHomeModules(String locale) async {
//     // 1️⃣ Read the asset manifest, discover all JSON files for this locale
//     final manifest =
//         json.decode(await rootBundle.loadString('AssetManifest.json'))
//             as Map<String, dynamic>;

//     final prefix = 'assets/data/$locale/';
//     final moduleKeys =
//         manifest.keys
//             .where((path) => path.startsWith(prefix) && path.endsWith('.json'))
//             .map(
//               (path) =>
//                   path.substring(prefix.length, path.length - '.json'.length),
//             )
//             .toList();

//     // 2️⃣ For each module, load its JSON and build a HomeModuleData
//     final sourceField = _localeField[locale] ?? _localeField['en']!;
//     return Future.wait(
//       moduleKeys.map((moduleKey) async {
//         final raw = await rootBundle.loadString('$prefix$moduleKey.json');
//         final list =
//             (json.decode(raw) as List<dynamic>).cast<Map<String, dynamic>>();

//         // pull out the "subcategory" (tile title)
//         final sub =
//             list.firstWhere(
//                   (m) => m.containsKey('subcategory'),
//                   orElse: () => <String, dynamic>{},
//                 )['subcategory']
//                 as String?;
//         final title = sub ?? moduleKey;

//         // build your Phrase list, ensuring each entry has the right fields
//         final phrases =
//             list
//                 .where(
//                   (m) =>
//                       m.containsKey(sourceField) && m.containsKey('papiamento'),
//                 )
//                 .map((m) => Phrase.fromJson(m, sourceField))
//                 .toList();

//         return HomeModuleData(
//           moduleKey: moduleKey,
//           title: title,
//           phrases: phrases,
//         );
//       }),
//     );
//   }
// }

// /// Represents one JSON file (“module”) on your home grid.
// class HomeModuleData {
//   /// e.g. "bank", "travel", ...
//   final String moduleKey;

//   /// the first `"subcategory"` value in that JSON, used as the tile's label
//   final String title;

//   /// the list of Phrase entries from that file (with sourceText chosen by locale)
//   final List<Phrase> phrases;

//   HomeModuleData({
//     required this.moduleKey,
//     required this.title,
//     required this.phrases,
//   });
// }

// /// A single phrase entry, with:
// ///  • sourceText   (in English/Spanish/Dutch/Chinese)
// ///  • papiamento   (always your Papiamento field)
// ///  • audio        (the filename, e.g. "Bank1.mp3")
// class Phrase {
//   final String sourceText;
//   final String papiamento;
//   final String audio;

//   Phrase({
//     required this.sourceText,
//     required this.papiamento,
//     required this.audio,
//   });

//   factory Phrase.fromJson(Map<String, dynamic> j, String sourceField) {
//     return Phrase(
//       sourceText: j[sourceField] as String? ?? '',
//       papiamento: j['papiamento'] as String? ?? '',
//       audio: j['audio'] as String? ?? '',
//     );
//   }
// }
