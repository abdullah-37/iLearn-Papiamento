import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('nl'),
    Locale('zh'),
  ];

  /// No description provided for @extras.
  ///
  /// In en, this message translates to:
  /// **'Extras'**
  String get extras;

  /// No description provided for @languages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languages;

  /// No description provided for @soundspeaker.
  ///
  /// In en, this message translates to:
  /// **'Sound Speaker'**
  String get soundspeaker;

  /// No description provided for @playauto.
  ///
  /// In en, this message translates to:
  /// **'Play Automatic'**
  String get playauto;

  /// No description provided for @speechspeed.
  ///
  /// In en, this message translates to:
  /// **'Speech Speed'**
  String get speechspeed;

  /// No description provided for @sharethisapp.
  ///
  /// In en, this message translates to:
  /// **'Share this app'**
  String get sharethisapp;

  /// No description provided for @ratenow.
  ///
  /// In en, this message translates to:
  /// **'Rate Now'**
  String get ratenow;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @facebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebook;

  /// No description provided for @twitter.
  ///
  /// In en, this message translates to:
  /// **'Twitter'**
  String get twitter;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @visitourpage.
  ///
  /// In en, this message translates to:
  /// **'Visit our webpage'**
  String get visitourpage;

  /// No description provided for @facebooksupport.
  ///
  /// In en, this message translates to:
  /// **'Facebook/Support'**
  String get facebooksupport;

  /// No description provided for @likeusonfacebook.
  ///
  /// In en, this message translates to:
  /// **'Like us on Facebook'**
  String get likeusonfacebook;

  /// No description provided for @followontwitter.
  ///
  /// In en, this message translates to:
  /// **'Follow on Twitter'**
  String get followontwitter;

  /// No description provided for @removeads.
  ///
  /// In en, this message translates to:
  /// **'Remove Ads'**
  String get removeads;

  /// No description provided for @nofavourites.
  ///
  /// In en, this message translates to:
  /// **'No Favorites!'**
  String get nofavourites;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @get_ad_free_experience_for.
  ///
  /// In en, this message translates to:
  /// **'Get an ad-free experience for'**
  String get get_ad_free_experience_for;

  /// No description provided for @buy_for.
  ///
  /// In en, this message translates to:
  /// **'Buy for'**
  String get buy_for;

  /// No description provided for @papiamento.
  ///
  /// In en, this message translates to:
  /// **'Papiamento'**
  String get papiamento;

  /// No description provided for @unlock_premium_features.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium Features'**
  String get unlock_premium_features;

  /// No description provided for @dictionary.
  ///
  /// In en, this message translates to:
  /// **'Dictionary'**
  String get dictionary;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @continuee.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continuee;

  /// No description provided for @description1m.
  ///
  /// In en, this message translates to:
  /// **'Go Add-Free – Enjoy Learn Papiamento without Ads for 30 Days'**
  String get description1m;

  /// No description provided for @description1y.
  ///
  /// In en, this message translates to:
  /// **'Go Add-Free – Enjoy Learn Papiamento without Ads for 12 Months'**
  String get description1y;

  /// No description provided for @description2.
  ///
  /// In en, this message translates to:
  /// **'Access to our Papiamento Dictionary which contains over 3000 words (No Audio yet, Audio will be implemented in future versions)'**
  String get description2;

  /// No description provided for @description3.
  ///
  /// In en, this message translates to:
  /// **'During the subscription, all upcoming premium features are automatically accessible.'**
  String get description3;

  /// No description provided for @description4.
  ///
  /// In en, this message translates to:
  /// **'Better app experience without interruptions'**
  String get description4;

  /// No description provided for @products_not_found.
  ///
  /// In en, this message translates to:
  /// **'Products not found.'**
  String get products_not_found;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'nl', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'nl':
      return AppLocalizationsNl();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
