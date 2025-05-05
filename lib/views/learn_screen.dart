import 'package:flutter/material.dart';
import 'package:ilearn_papiamento/config/config.dart';
import 'package:ilearn_papiamento/config/images.dart';
import 'package:ilearn_papiamento/models/data_model.dart';
import 'package:ilearn_papiamento/providers/fetch_data_provider.dart';
import 'package:ilearn_papiamento/views/category_side_bar.dart';
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
    final size = MediaQuery.of(context).size;
    final panelWidth = size.width * 0.8;
    // Hook both icons up to the new toggle:
    var mainContainer = LearnContentWidget(
      color: Color(widget.color),
      lefticon: GestureDetector(
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
      modulekey: _currentModuleKey,
      // islicked: ctrl.value > 0.5,
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
                  child: CategorySideBar(
                    onCategoryTap: (String newKey) {
                      setState(() {
                        _currentModuleKey =
                            newKey; // update the selected category
                        toggle(left: true); // close the sidebar
                      });
                      // ctrl.reverse(); // animate it closed
                    },
                  ),
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

class LearnContentWidget extends StatefulWidget {
  final VoidCallback onSettingsTap;
  final Widget iconWidget;
  final String modulekey;
  final Widget lefticon;
  final Color color;

  const LearnContentWidget({
    required this.iconWidget,
    required this.lefticon,
    required this.onSettingsTap,
    required this.color,
    required this.modulekey,
    super.key,
  });

  @override
  _LearnContentWidgetState createState() => _LearnContentWidgetState();
}

class _LearnContentWidgetState extends State<LearnContentWidget> {
  /// Tracks which word is expanded per subcategory index
  final Map<int, int?> _expandedIndexPerSub = {};

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final provider = Provider.of<FetchDataProvider>(context);
    final categoriesData = provider.categoriesData;

    if (categoriesData?.data == null) {
      return _buildScaffold(
        context,
        title: 'iLearn Papiamento',
        child: const Center(child: Text('Data not available')),
      );
    }

    final category = categoriesData!.data!.firstWhere(
      (cat) => cat.categoryId == widget.modulekey,
      orElse: () => Datum(),
    );
    String appbartitle = '';
    switch (lang) {
      case 'en':
        appbartitle = category.categoryEng ?? '';
        break;
      case 'es':
        appbartitle = category.categorySpan ?? '';
        break;
      case 'nl':
        appbartitle = category.categoryDutch ?? '';
        break;
      case 'zh':
        appbartitle = category.categoryChine ?? '';
        break;
      default:
        appbartitle = category.categoryEng ?? '';
    }

    if (category.categoryId == null) {
      return _buildScaffold(
        context,
        title: appbartitle,
        child: const Center(child: Text('Category not found')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(appbartitle, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: widget.color,
        elevation: 0,
        leading: widget.lefticon,
        actions: [widget.iconWidget, const SizedBox(width: 10)],
      ),
      body: ListView.builder(
        itemCount: category.subcategories?.length ?? 0,
        itemBuilder: (context, subIndex) {
          final sub = category.subcategories![subIndex];
          final words = sub.words ?? [];

          // Determine subcategory title by locale
          final subname = () {
            switch (lang) {
              case 'en':
                return sub.subcategoryEng ?? '';
              case 'es':
                return sub.subcategorySpan ?? '';
              case 'nl':
                return sub.subcategoryDutch ?? '';
              case 'zh':
                return sub.subcategoryChine ?? '';
              default:
                return sub.subcategoryEng ?? '';
            }
          }();

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subcategory heading
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 13,
                    horizontal: 20,
                  ),
                  decoration: const BoxDecoration(color: Color(0xFF434343)),
                  child: Text(
                    subname.isNotEmpty ? subname : 'Untitled',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Words list with single-expand behavior
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: words.length,
                  itemBuilder: (ctx, wordIndex) {
                    final word = words[wordIndex];
                    final isExpanded =
                        _expandedIndexPerSub[subIndex] == wordIndex;

                    return CustomLearnTile(
                      color: widget.color,
                      word: word,
                      isExpanded: isExpanded,
                      onTileTap: () {
                        setState(() {
                          final currently = _expandedIndexPerSub[subIndex];
                          // Toggle: collapse if same, else open new
                          _expandedIndexPerSub[subIndex] =
                              (currently == wordIndex) ? null : wordIndex;
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Scaffold _buildScaffold(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: widget.color,
        elevation: 0,
        leading: widget.lefticon,
        actions: [widget.iconWidget, const SizedBox(width: 10)],
      ),
      body: child,
    );
  }
}
