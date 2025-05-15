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
import 'package:ilearn_papiamento/providers/control_ads_provider.dart';
import 'package:ilearn_papiamento/providers/dictionary_provider.dart';
import 'package:ilearn_papiamento/providers/favourite_provider.dart';
import 'package:ilearn_papiamento/providers/fetch_data_provider.dart';
import 'package:ilearn_papiamento/providers/purchase_provider.dart';
import 'package:ilearn_papiamento/views/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final audioService = AudioService();
  await SharedPrefsService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ControlAdsProvider()),

        ChangeNotifierProvider(create: (_) => AdsProvider()),
        ChangeNotifierProvider(create: (_) => IAPProvider()),
        ChangeNotifierProvider(create: (_) => DictionaryProvider()),

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
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.appBg,
        fontFamily: AppConfig.avenir,
      ),
      debugShowCheckedModeBanner: false,
      locale: appLang.locale,
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('nl'),
        Locale('zh'),
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
