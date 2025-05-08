import 'package:flutter/material.dart';
import 'package:flutter_circular_progress_indicator/flutter_circular_progress_indicator.dart';
import 'package:ilearn_papiamento/config/images.dart';
import 'package:ilearn_papiamento/providers/fetch_data_provider.dart';
import 'package:ilearn_papiamento/views/home_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // var adsProvider = Provider.of<AdsProvider>(context, listen: true);

    return Scaffold(
      body: Consumer<FetchDataProvider>(
        builder: (context, provider, child) {
          // Navigate to HomeScreen when isLoading becomes false
          if (provider.categoriesData != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            });
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Image.asset(
                  AppImages.splashlogo,
                  // fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 50,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CircularProgressInd().normalCircular(
                    height: 40,
                    width: 40,
                    isSpining: true,
                    spinDuration: const Duration(seconds: 1),
                    valueColor: Colors.black,
                    secondaryColor: Colors.white,
                    secondaryWidth: 5,
                    valueWidth: 3,
                    value: 0.1,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
