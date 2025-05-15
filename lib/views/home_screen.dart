import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ilearn_papiamento/config/app_colors.dart';
import 'package:ilearn_papiamento/config/config.dart';
import 'package:ilearn_papiamento/config/images.dart';
import 'package:ilearn_papiamento/providers/ads_provider.dart';
import 'package:ilearn_papiamento/providers/control_ads_provider.dart';
import 'package:ilearn_papiamento/providers/fetch_data_provider.dart';
import 'package:ilearn_papiamento/providers/purchase_provider.dart';
import 'package:ilearn_papiamento/views/favourite_screen.dart';
import 'package:ilearn_papiamento/views/learn_screen.dart';
import 'package:ilearn_papiamento/views/settings_screen.dart';
import 'package:ilearn_papiamento/widgets/Premium_Items_grid.dart.dart';
import 'package:ilearn_papiamento/widgets/home_grid_widget.dart';
import 'package:ilearn_papiamento/widgets/line_below_appbar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppConfig.animationDuration),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  /// Toggle open/close
  void _toggle() {
    if (_ctrl.isCompleted) {
      _ctrl.reverse();
    } else {
      _ctrl.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    var adsProvider = context.watch<AdsProvider>(); // listens and rebuilds
    final adsRemoved = context.watch<IAPProvider>().adsRemoved;

    final size = MediaQuery.of(context).size;
    final panelWidth = size.width * 0.8;
    var mainContainer = MainContentWidget(
      onSettingsTap: _toggle,
      iconWidget: GestureDetector(
        onTap: _toggle,
        // Update controller.value as we drag
        onHorizontalDragUpdate: (details) {
          final delta = details.primaryDelta ?? 0;
          _ctrl.value = (_ctrl.value - delta / panelWidth).clamp(0.0, 1.0);
        },
        // On release, snap open/closed based on velocity or position
        onHorizontalDragEnd: (details) {
          final v = details.primaryVelocity ?? 0;
          if (v.abs() > 300) {
            // fling in direction of swipe
            _ctrl.fling(velocity: v < 0 ? 1 : -1);
          } else {
            // snap by midpoint
            _ctrl.fling(velocity: _ctrl.value > 0.5 ? 1 : -1);
          }
        },
        child: const Icon(Icons.settings, color: Colors.white, size: 35),
      ),
      // consider open if controller is past halfway
      isClicked: _ctrl.value > 0.5,
    );
    var settinWidget = const SettingsPanelWidget();

    return SafeArea(
      child: Scaffold(
        // Use AnimatedBuilder so the Stack rebuilds on each tick of the controller
        body: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            // how far we've slid, from 0 (closed) to panelWidth (open)
            final slide = panelWidth * _ctrl.value;

            return Stack(
              children: [
                // ——— SETTINGS PANEL ———
                Positioned(
                  top: 0,
                  bottom: 0,
                  // panel’s left edge = screenWidth – how far we’ve slid
                  right: _ctrl.value,
                  left: size.width * 0.2,

                  // width: panelWidth,
                  child: settinWidget,
                ),
                // ——— DRAGGABLE MAIN CONTENT ———
                Positioned(
                  top: 0,
                  bottom: 00,
                  left: -slide,
                  right: slide,
                  child: GestureDetector(
                    // Update controller.value as we drag
                    onHorizontalDragUpdate: (details) {
                      final delta = details.primaryDelta ?? 0;
                      _ctrl.value = (_ctrl.value - delta / panelWidth).clamp(
                        0.0,
                        1.0,
                      );
                    },
                    // On release, snap open/closed based on velocity or position
                    onHorizontalDragEnd: (details) {
                      final v = details.primaryVelocity ?? 0;
                      if (v.abs() > 300) {
                        // fling in direction of swipe
                        _ctrl.fling(velocity: v < 0 ? 1 : -1);
                      } else {
                        // snap by midpoint
                        _ctrl.fling(velocity: _ctrl.value > 0.5 ? 1 : -1);
                      }
                    },
                    child: Column(
                      children: [
                        Expanded(child: mainContainer),
                        if (!adsRemoved)
                          adsProvider.isBannerLoaded
                              ? Container(
                                color: Colors.black,
                                height:
                                    adsProvider.bannerAd!.size.height
                                        .toDouble(),
                                width: double.infinity,
                                // adsProvider.bannerAd!.size.width.toDouble(),
                                child: AdWidget(ad: adsProvider.bannerAd!),
                              )
                              : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
                //
                // ads
                // Positioned(
                //   left: 0,
                //   right: 0,
                //   bottom: 0,
                //   height: 50,
                //   child:
                //       adsProvider.isLoaded
                //           ? SizedBox(
                //             height:
                //                 adsProvider.bannerAd!.size.height.toDouble(),
                //             width: adsProvider.bannerAd!.size.width.toDouble(),
                //             child: AdWidget(ad: adsProvider.bannerAd!),
                //           )
                //           : const SizedBox.shrink(),
                // ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class MainContentWidget extends StatelessWidget {
  final VoidCallback onSettingsTap;
  final Widget iconWidget;
  final bool isClicked;

  const MainContentWidget({
    required this.iconWidget,
    required this.onSettingsTap,
    required this.isClicked,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final controlads = Provider.of<ControlAdsProvider>(context, listen: true);

    final lang = Localizations.localeOf(context).languageCode;
    String flagImage;
    switch (lang) {
      case 'en':
        flagImage = AppImages.englishflag;
        break;
      case 'es':
        flagImage = AppImages.espanolflag;
        break;
      case 'nl':
        flagImage = AppImages.dutchflag;
        break;
      case 'zh':
        flagImage = AppImages.chineseflag;
        break;
      default:
        flagImage = AppImages.englishflag;
    }

    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 21, 21, 21),
            spreadRadius: 3,
            blurRadius: 6,
          ),
        ],
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            'iLearn ${appLocalizations.papiamento}', // Replace with AppStrings.appName
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontFamily: AppConfig.aero,
            ),
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: LineBelowAppBar(),
          ),
          centerTitle: true,
          backgroundColor: AppColors.appBg, // Replace with AppColors.appBg
          elevation: 0,
          actions: [iconWidget, const SizedBox(width: 20)],
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Image.asset(flagImage),
          ),
        ),
        body: Consumer<FetchDataProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.categoriesData == null ||
                provider.categoriesData!.data == null) {
              return const Center(child: Text('Failed to load categories'));
            }
            final categories = provider.categoriesData!.data!;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 13,
                    mainAxisSpacing: 13,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, i) {
                    final category = categories[i];
                    String name;
                    switch (lang) {
                      case 'en':
                        name = category.categoryEng ?? '';
                        flagImage = AppImages.englishflag;
                        break;
                      case 'es':
                        name = category.categorySpan ?? '';
                        flagImage = AppImages.dutchflag;

                        break;
                      case 'nl':
                        name = category.categoryDutch ?? '';
                        flagImage = AppImages.espanolflag;

                        break;
                      case 'zh':
                        name = category.categoryChine ?? '';
                        flagImage = AppImages.chineseflag;

                      default:
                        name = category.categoryEng ?? '';
                        flagImage = AppImages.englishflag;
                    }
                    return GestureDetector(
                      onTap: () {
                        controlads.incrementCatViews();
                        if (category.categoryId == '20') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => FavoritesScreen(
                                    category: category,
                                    color: int.parse(
                                      "FF${category.color}",
                                      radix: 16,
                                    ),
                                  ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => LearnScreen(
                                    color: int.parse(
                                      "FF${category.color}",
                                      radix: 16,
                                    ),
                                    moduleKey: category.categoryId ?? '',
                                  ),
                            ),
                          );
                        }
                      },
                      child: HomeGridWidget(category: category),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Premium Features
                Container(
                  height: 50,
                  color: AppColors.learnTileopenedbg,
                  child: const Center(
                    child: Text(
                      'Premium Features',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const PremiumItems(),

                // //remove adds
                // //
              ],
            );
          },
        ),
      ),
    );
  }
}
