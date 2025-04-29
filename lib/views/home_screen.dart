import 'package:flutter/material.dart';
import 'package:ilearn_papiamento/config/app_colors.dart';
import 'package:ilearn_papiamento/config/app_strings.dart';
import 'package:ilearn_papiamento/data.dart';
import 'package:ilearn_papiamento/data_loader.dart';
import 'package:ilearn_papiamento/views/learn_screen.dart';
import 'package:ilearn_papiamento/views/settings_screen.dart';
import 'package:ilearn_papiamento/widgets/home_grid_widget.dart';

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
      duration: const Duration(milliseconds: 400),
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
    final size = MediaQuery.of(context).size;
    final panelWidth = size.width * 0.8;
    var mainContainer = MainContentWidget(
      onSettingsTap: _toggle,
      // consider open if controller is past halfway
      isClicked: _ctrl.value > 0.5,
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.appBg,
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
                  right: 0,
                  width: panelWidth,
                  child: SettingsPanelWidget(onClose: _toggle),
                ),
                // ——— DRAGGABLE MAIN CONTENT ———
                Positioned(
                  top: 0,
                  bottom: 0,
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
                    child: mainContainer,
                  ),
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
  final bool isClicked;
  const MainContentWidget({
    required this.onSettingsTap,
    super.key,
    required this.isClicked,
  });

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return Scaffold(
      backgroundColor: AppColors.appBg,
      appBar: AppBar(
        title: const Text(
          AppStrings.appName,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.appBg,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: onSettingsTap,
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.white24),
        ),
      ),
      body: FutureBuilder<List<HomeModuleData>>(
        future: DataService.loadHomeModules(lang),
        builder: (ctx, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final tiles = snap.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: tiles.length,
            itemBuilder: (context, i) {
              final ht = tiles[i];
              return GestureDetector(
                onTap: () {
                  if (!isClicked) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => LearnScreen(
                              color: AppColors.appBg,
                              moduleKey: ht.moduleKey,
                            ),
                      ),
                    );
                  }
                },
                child: HomeGridWidget(name: ht.title, tile: homeTiles[i]),
              );
            },
          );
        },
      ),
    );
  }
}
