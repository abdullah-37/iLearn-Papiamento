import 'package:flutter/material.dart';
import 'package:ilearn_papiamento/config/config.dart';
import 'package:ilearn_papiamento/config/images.dart';
import 'package:ilearn_papiamento/models/data_model.dart';
import 'package:ilearn_papiamento/providers/ads_provider.dart';
import 'package:ilearn_papiamento/providers/app_settings_provider.dart';
import 'package:ilearn_papiamento/providers/audio_provider.dart';
import 'package:ilearn_papiamento/providers/control_ads_provider.dart';
import 'package:ilearn_papiamento/providers/favourite_provider.dart';
import 'package:ilearn_papiamento/providers/fetch_data_provider.dart';
import 'package:ilearn_papiamento/views/category_side_bar.dart';
import 'package:ilearn_papiamento/views/favourite_screen.dart';
import 'package:ilearn_papiamento/views/settings_screen.dart';
import 'package:ilearn_papiamento/widgets/words_tile.dart';
import 'package:provider/provider.dart';

class LearnScreen extends StatefulWidget {
  final int color;
  final String moduleKey;
  const LearnScreen({super.key, required this.moduleKey, required this.color});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController ctrl;
  bool _openLeft = false; // ← new
  String _currentModuleKey = '';

  @override
  void initState() {
    super.initState();
    ctrl = AnimationController(
      animationBehavior: AnimationBehavior.preserve,
      vsync: this,
      duration: const Duration(milliseconds: AppConfig.animationDuration),
    );
    _currentModuleKey = widget.moduleKey; // initialize it
  }

  // New toggle signature:
  void toggle({required bool left}) {
    _openLeft = left;
    if (ctrl.isCompleted) {
      ctrl.reverse();
    } else {
      ctrl.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final adsProvider = Provider.of<AdsProvider>(context, listen: false);
    final controlads = Provider.of<ControlAdsProvider>(context, listen: false);
    if (controlads.numberOfCateOpen == 0) {
      adsProvider.showInterstitialAd();
    }

    // Somewhere in your logic:
    final size = MediaQuery.of(context).size;
    final panelWidth = size.width * 0.8;
    // Hook both icons up to the new toggle:
    var mainContainer = LearnContentWidget(
      color: Color(widget.color),
      leftIcon: GestureDetector(
        onHorizontalDragUpdate: (details) {
          // Reverse drag: dragging right (positive delta) increases value
          _openLeft = true;
          final delta = details.primaryDelta ?? 0;
          ctrl.value = (ctrl.value + delta / panelWidth).clamp(0.0, 1.0);
        },
        onHorizontalDragEnd: (details) {
          _openLeft = true;
          final v = details.primaryVelocity ?? 0;
          if (v.abs() > 300) {
            // fling: positive v opens, negative closes
            ctrl.fling(velocity: v > 0 ? 1 : -1);
          } else {
            // snap by midpoint
            ctrl.fling(velocity: ctrl.value > 0.5 ? 1 : -1);
          }
        },
        onTap: () => toggle(left: true), // ← open left

        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Image.asset(AppImages.category),
        ),
      ),
      iconWidget: GestureDetector(
        onTap: () => toggle(left: false), // ← open right
        onHorizontalDragUpdate: (details) {
          _openLeft = false;

          final delta = details.primaryDelta ?? 0;
          ctrl.value = (ctrl.value - delta / panelWidth).clamp(0.0, 1.0);
        },
        // On release, snap open/closed based on velocity or position
        onHorizontalDragEnd: (details) {
          _openLeft = false;

          final v = details.primaryVelocity ?? 0;
          if (v.abs() > 300) {
            // fling in direction of swipe
            ctrl.fling(velocity: v < 0 ? 1 : -1);
          } else {
            // snap by midpoint
            ctrl.fling(velocity: ctrl.value > 0.5 ? 1 : -1);
          }
        },
        child: const Icon(Icons.settings, color: Colors.white, size: 35),
      ),
      // pass through:
      onSettingsTap: () {},
      moduleKey: _currentModuleKey,
      // islicked: ctrl.value > 0.5,
    );
    final sideCategories = CategorySideBar(
      onCategoryTap: (String newKey) {
        final provider = Provider.of<FetchDataProvider>(context, listen: false);

        final data = provider.categoriesData?.data;

        final cat = data!.firstWhere(
          (c) => c.categoryId == newKey,
          orElse: () => Datum(),
        );
        // print(newKey);

        if (newKey == '20') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => FavoritesScreen(
                    category: cat,
                    color: int.parse("FF${cat.color}", radix: 16),
                  ),
            ),
          );
        } else {
          setState(() {
            _currentModuleKey = newKey; // update the selected category
            toggle(left: true); // close the sidebar
          });
        }

        // ctrl.reverse(); // animate it closed
      },
    );

    return Scaffold(
      body: AnimatedBuilder(
        animation: ctrl,
        builder: (context, _) {
          final slide = panelWidth * ctrl.value;

          return Stack(
            children: [
              // Only one panel: either left OR right
              if (_openLeft)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: panelWidth,
                  child: sideCategories,
                )
              else
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: panelWidth,
                  child: const SettingsPanelWidget(),
                ),

              // Shift main content right when _openLeft, left when not.
              Positioned(
                top: 0,
                bottom: 0,
                left: _openLeft ? slide : -slide,
                right: _openLeft ? -slide : slide,
                child: mainContainer,
              ),
            ],
          );
        },
      ),
    );
  }
}

class ActionIcon extends StatelessWidget {
  final String image;
  final VoidCallback onTap;
  const ActionIcon({super.key, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Image.asset(image, height: 30), onPressed: onTap);
  }
}

/// Main content widget that displays categories and words
class LearnContentWidget extends StatefulWidget {
  final VoidCallback onSettingsTap;
  final Widget iconWidget;
  final Widget leftIcon;
  final Color color;
  final String moduleKey;

  const LearnContentWidget({
    super.key,
    required this.onSettingsTap,
    required this.iconWidget,
    required this.leftIcon,
    required this.color,
    required this.moduleKey,
  });

  @override
  _LearnContentWidgetState createState() => _LearnContentWidgetState();
}

class _LearnContentWidgetState extends State<LearnContentWidget> {
  final Map<int, int?> _expandedPerSub = {};

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FetchDataProvider>();
    final data = provider.categoriesData?.data;
    if (data == null) {
      return _buildLoading();
    }

    final cat = data.firstWhere(
      (c) => c.categoryId == widget.moduleKey,
      orElse: () => Datum(),
    );
    if (cat.categoryId == null) {
      return _buildError('Category not found');
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
          centerTitle: true,
          leading: widget.leftIcon,
          title: Text(
            _titleFor(cat, context),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(int.parse("FF${cat.color}", radix: 16)),
          actions: [widget.iconWidget, const SizedBox(width: 10)],
        ),
        body: ListView.builder(
          itemCount: cat.subcategories?.length ?? 0,
          itemBuilder: (ctx, subIdx) {
            final sub = cat.subcategories![subIdx];
            final words = sub.words ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  color: const Color(0xFF434343),
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _subTitleFor(sub, context),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: words.length,
                  itemBuilder: (c, wIdx) {
                    final speed =
                        context.watch<AppSettingsProvider>().speedValue;
                    final autoPlay =
                        context.watch<AppSettingsProvider>().isVoiceAuto;

                    final isExp = _expandedPerSub[subIdx] == wIdx;
                    // isFav = await FavoritesService.isFavorite(widget.word.learnContentsId!);

                    return CustomLearnTile(
                      isFav: context.read<FavoritesProvider>().isFavorite(
                        words[wIdx].learnContentsId!,
                      ),
                      color: Color(int.parse("FF${cat.color}", radix: 16)),
                      word: words[wIdx],
                      isExpanded: isExp,
                      voiceSpeed: speed,
                      onTileTap: () async {
                        setState(
                          () => _expandedPerSub[subIdx] = isExp ? null : wIdx,
                        );
                        if (autoPlay && !isExp) {
                          try {
                            await context.read<AudioProvider>().play(
                              words[wIdx].audioFile!,
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
              ],
            );
          },
        ),
      ),
    );
  }

  Scaffold _buildLoading() => Scaffold(
    appBar: AppBar(
      backgroundColor: widget.color,
      leading: widget.leftIcon,
      title: const Text('Loading...', style: TextStyle(color: Colors.white)),
    ),
    body: const Center(child: CircularProgressIndicator()),
  );

  Scaffold _buildError(String message) => Scaffold(
    appBar: AppBar(
      backgroundColor: widget.color,
      leading: widget.leftIcon,
      title: Text(message, style: const TextStyle(color: Colors.white)),
    ),
    body: Center(
      child: Text(message, style: const TextStyle(color: Colors.white)),
    ),
  );

  String _titleFor(Datum cat, BuildContext ctx) {
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

  String _subTitleFor(Subcategory sub, BuildContext ctx) {
    final lang = Localizations.localeOf(ctx).languageCode;
    return {
          'en': sub.subcategoryEng,
          'es': sub.subcategorySpan,
          'nl': sub.subcategoryDutch,
          'zh': sub.subcategoryChine,
        }[lang] ??
        sub.subcategoryEng ??
        '';
  }
}
