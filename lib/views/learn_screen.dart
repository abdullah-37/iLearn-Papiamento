import 'package:flutter/material.dart';
import 'package:ilearn_papiamento/config/app_colors.dart';
import 'package:ilearn_papiamento/config/app_strings.dart';
import 'package:ilearn_papiamento/config/config.dart';
import 'package:ilearn_papiamento/data_loader.dart';
import 'package:ilearn_papiamento/views/category_side_bar.dart';
import 'package:ilearn_papiamento/views/settings_screen.dart';
import 'package:ilearn_papiamento/widgets/line_below_appbar.dart';
import 'package:ilearn_papiamento/widgets/words_tile.dart';

class LearnScreen extends StatefulWidget {
  final Color color;
  final String moduleKey;
  const LearnScreen({super.key, required this.moduleKey, required this.color});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController ctrl;
  bool _openLeft = false; // ← new

  @override
  void initState() {
    super.initState();
    ctrl = AnimationController(
      animationBehavior: AnimationBehavior.preserve,
      vsync: this,
      duration: const Duration(milliseconds: AppConfig.animationDuration),
    );
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
    var mainContainer = MainContentWidget(
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

        child: const Icon(Icons.settings, color: Colors.white, size: 35),
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
      modulekey: widget.moduleKey,
      isClicked: ctrl.value > 0.5,
    );

    return SafeArea(
      child: Scaffold(
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
                    child: const CategorySideBar(),
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
      ),
    );
  }
}

class MainContentWidget extends StatelessWidget {
  final VoidCallback onSettingsTap;
  final Widget iconWidget;
  final bool isClicked;
  final String modulekey;
  final Widget lefticon;
  const MainContentWidget({
    required this.iconWidget,
    required this.lefticon,
    required this.onSettingsTap,
    super.key,
    required this.isClicked,
    required this.modulekey,
  });

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.appName,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.appBg,
        elevation: 0,
        leading: lefticon,
        actions: [iconWidget, const SizedBox(width: 20)],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: LineBelowAppBar(),
        ),
      ),
      body: FutureBuilder<List<Phrase>>(
        future: DataService.loadPhrases(modulekey, lang),
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final phrases = snap.data!;
          return ListView(
            children:
                phrases
                    .map((p) => PhraseTile(color: Colors.red, phrase: p))
                    .toList(),
          );
        },
      ),
    );
  }
}
