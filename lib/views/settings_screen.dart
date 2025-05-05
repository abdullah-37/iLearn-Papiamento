import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ilearn_papiamento/config/app_colors.dart';
import 'package:ilearn_papiamento/config/app_strings.dart';
import 'package:ilearn_papiamento/config/images.dart';
import 'package:ilearn_papiamento/views/language_selection_screen.dart';
import 'package:ilearn_papiamento/widgets/slider.dart';

// import 'package:in_app_purchase/in_app_purchase.dart';

class SettingsPanelWidget extends StatefulWidget {
  // final VoidCallback onClose;
  const SettingsPanelWidget({super.key});

  @override
  State<SettingsPanelWidget> createState() => _SettingsPanelWidgetState();
}

class _SettingsPanelWidgetState extends State<SettingsPanelWidget> {
  double sliderValue = 0;
  bool isVoiceAuto = false;
  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;

    String selectedLanguuage = 'English';
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    switch (lang) {
      case 'en':
        selectedLanguuage = 'English' ?? '';
        break;
      case 'es':
        selectedLanguuage = 'Dutch' ?? '';
        break;
      case 'nl':
        selectedLanguuage = 'Espanol' ?? '';
        break;
      case 'zh':
        selectedLanguuage = '中文' ?? '';
      default:
        selectedLanguuage = 'English' ?? '';
    }

    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15,
          children: [
            //
            CustomSettingContainer(
              title: appLocalizations.extras,
              color: const Color(0xFFCB7954),
              height: height,
            ),
            //
            GestureDetector(
              onTap: () {
                // purchaseProvider.buyProduct(
                //   ProductDetails(
                //     id: 'remove_ads',
                //     title: 'Remove Ads',
                //     description: 'This will remove adds',
                //     price: '300',
                //     rawPrice: 300.00,
                //     currencyCode: 'Rs',
                //   ),
                //   consumable: false,
                // );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: CustomSettingText(text: appLocalizations.removeads),
              ),
            ),
            CustomSettingContainer(
              title: appLocalizations.languages,
              color: const Color(0xFFCB7954),
              height: height,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LanguageSelectionScreen(),
                    ),
                  );
                },
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //
                      CustomSettingText(text: selectedLanguuage),
                      const Icon(
                        Icons.keyboard_arrow_right,
                        size: 30,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CustomSettingContainer(
              height: height,
              title: appLocalizations.soundspeaker,
              color: const Color(0xFFF39134),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(AppImages.voiceFemaleImage, height: 40),
                  const SizedBox(width: 10),

                  //
                  const CustomSettingText(text: 'Marjetie'),
                  const Spacer(),
                  Image.asset(AppImages.checkImage, height: 20),
                ],
              ),
            ),

            CustomSettingContainer(
              title: appLocalizations.playauto,
              color: const Color(0xFF3BBDB1),
              height: height,
            ),
            Switch.adaptive(
              activeTrackColor: Colors.green,

              value: isVoiceAuto,
              onChanged: (v) {
                setState(() {
                  isVoiceAuto = !isVoiceAuto;
                });
              },
            ),
            CustomSettingContainer(
              title: appLocalizations.speechspeed,
              color: const Color(0xFF3A9ABD),
              height: height,
            ),
            const SizedBox(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                spacing: 8,
                children: [
                  Image.asset(AppImages.imgslow, height: 20),
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: CustomProgressSlider(
                        height: 23,
                        value: sliderValue,
                        onChanged: (v) {
                          setState(() {
                            sliderValue = v;
                            // print(v);
                          });
                        },
                      ),
                    ),
                  ),
                  Image.asset(AppImages.imgfast, height: 20),
                ],
              ),
            ),

            const SizedBox(height: 1),
            CustomSettingContainer(
              title: appLocalizations.sharethisapp,
              color: const Color(0xFFF2695F),
              height: height,
            ),
            //
            SettingTile(
              image: AppImages.android,
              title: appLocalizations.ratenow,
            ),
            SettingTile(image: AppImages.email, title: appLocalizations.email),

            SettingTile(
              image: AppImages.facebook,
              title: appLocalizations.facebook,
            ),
            SettingTile(
              image: AppImages.twitter,
              title: appLocalizations.twitter,
            ),
            CustomSettingContainer(
              height: height,
              color: const Color(0xFFBF5F3B),
              title: '${appLocalizations.about} ${AppStrings.appName}',
            ),
            SettingTile(
              image: AppImages.visitourpage,
              title: appLocalizations.visitourpage,
            ),
            SettingTile(
              image: AppImages.email,
              title: appLocalizations.facebooksupport,
            ),
            SettingTile(
              image: AppImages.facebook,
              title: appLocalizations.likeusonfacebook,
            ),
            SettingTile(
              image: AppImages.twitter,
              title: appLocalizations.likeusonfacebook,
            ),
          ],
        ),
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  final String title;
  final String image;
  const SettingTile({super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListTile(
        onTap: () {},
        leading: Image.asset(image, height: 35),
        title: CustomSettingText(text: title),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Colors.grey,
        ),
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // children: [
        //   Image.asset(image, height: 35),
        //   const SizedBox(width: 10),
        //   CustomSettingText(text: title),
        //   const Spacer(),
        //   const Icon(Icons.keyboard_arrow_right, size: 30, color: Colors.grey),
        // ],
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
