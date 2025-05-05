import 'package:flutter/material.dart';
import 'package:ilearn_papiamento/config/app_colors.dart';
import 'package:ilearn_papiamento/providers/fetch_data_provider.dart';
import 'package:provider/provider.dart';

class CategorySideBar extends StatelessWidget {
  final void Function(String categoryId) onCategoryTap;

  const CategorySideBar({super.key, required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    // Use Provider.of instead of Consumer
    final provider = Provider.of<FetchDataProvider>(context, listen: false);

    if (provider.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.appBg,
        body: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    final data = provider.categoriesData?.data;
    if (data == null || data.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.appBg,
        body: const Center(
          child: Text(
            'No categories found',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.appBg,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            const Text(
              'CATEGORY',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 10),
            const Divider(color: Colors.white, thickness: 2),
            const SizedBox(height: 10),
            Expanded(
              child: RepaintBoundary(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final category = data[index];
                    String name;
                    switch (lang) {
                      case 'en':
                        name = category.categoryEng ?? '';
                        break;
                      case 'es':
                        name = category.categorySpan ?? '';
                        break;
                      case 'nl':
                        name = category.categoryDutch ?? '';
                        break;
                      case 'zh':
                        name = category.categoryChine ?? '';
                        break;
                      default:
                        name = category.categoryEng ?? '';
                    }

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onCategoryTap(category.categoryId!),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/imghotel.png',
                              height: 40,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Divider(
                                    color: Colors.white,
                                    thickness: 1,
                                    height: 1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
