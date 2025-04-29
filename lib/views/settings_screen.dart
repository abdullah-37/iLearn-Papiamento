import 'package:flutter/material.dart';
import 'package:ilearn_papiamento/config/app_colors.dart';

class SettingsPanelWidget extends StatelessWidget {
  final VoidCallback onClose;
  const SettingsPanelWidget({required this.onClose, super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: AppColors.appBg,
      appBar: AppBar(
        // centerTitle: true,
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.appBg,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.white24),
        ),
      ),
      // Replace this with your actual settings controls
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          //
          CustomSettingContainer(
            title: 'Extras',
            color: const Color(0xFFCB7954),
            height: height,
          ),
          //
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: CustomSettingText(text: 'Remove Ads'),
          ),
          CustomSettingContainer(
            title: 'Language',
            color: const Color(0xFFCB7954),
            height: height,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                //
                CustomSettingText(text: 'English'),
              ],
            ),
          ),
          CustomSettingContainer(
            height: height,
            title: 'Sound Speaker',
            color: const Color(0xFFF39134),
          ),
          CustomSettingContainer(
            title: 'Play Automatically',
            color: const Color(0xFF3BBDB1),
            height: height,
          ),
          CustomSettingContainer(
            title: 'Speech Speed',
            color: const Color(0xFF3A9ABD),
            height: height,
          ),
          CustomSettingContainer(
            title: 'Share this app',
            color: const Color(0xFFF2695F),
            height: height,
          ),
        ],
      ),
    );
  }
}

class CustomSettingText extends StatelessWidget {
  final String text;
  const CustomSettingText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(color: Colors.white));
  }
}

class CustomSettingContainer extends StatelessWidget {
  final Color color;
  final String title;
  final double height;
  const CustomSettingContainer({
    super.key,
    required this.height,
    required this.color,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height * 0.07,
      decoration: BoxDecoration(color: color),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            textAlign: TextAlign.start,
            title,
            style: const TextStyle(color: Colors.white, fontSize: 19),
          ),
        ),
      ),
    );
  }
}
