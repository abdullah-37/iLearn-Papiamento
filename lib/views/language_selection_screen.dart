import 'package:flutter/material.dart';
import 'package:ilearn_papiamento/config/images.dart';
import 'package:ilearn_papiamento/providers/app_settings_provider.dart';
import 'package:provider/provider.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appLanguage = Provider.of<AppSettingsProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFCB7954),
        title: const Text(
          'Select Language',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          //
          LanguageTile(
            isSelected: appLanguage.locale == const Locale('en'),
            title: 'English',
            subtitle: 'English',
            onTap: () {
              appLanguage.changeLanguage('en');
            },
          ),
          LanguageTile(
            isSelected: appLanguage.locale == const Locale('es'),

            title: 'Nederland',
            subtitle: 'Dutch',
            onTap: () {
              appLanguage.changeLanguage('es');
            },
          ),
          LanguageTile(
            isSelected: appLanguage.locale == const Locale('nl'),

            title: 'Espanol',
            subtitle: 'Espanol',
            onTap: () {
              appLanguage.changeLanguage('nl');
            },
          ),
          LanguageTile(
            isSelected: appLanguage.locale == const Locale('zh'),

            title: '中文',
            subtitle: 'Chinese',
            onTap: () {
              appLanguage.changeLanguage('zh');
            },
          ),
        ],
      ),
    );
  }
}

class LanguageTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final GestureTapCallback onTap;
  final bool isSelected;
  const LanguageTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: const BoxDecoration(
          color: Color(0xFF303236),
          border: Border(
            bottom: BorderSide(color: Color(0xFF526E94), width: 2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                ),
                Text(subtitle, style: const TextStyle(color: Colors.white)),
              ],
            ),
            if (isSelected) Image.asset(AppImages.checkImage, height: 20),
          ],
        ),
      ),
    );
  }
}
