import 'package:flutter/material.dart';
import 'package:ilearn_papiamento/config/app_colors.dart';
import 'package:ilearn_papiamento/config/config.dart';
import 'package:ilearn_papiamento/config/images.dart';
import 'package:ilearn_papiamento/l10n/app_localizations.dart';
import 'package:ilearn_papiamento/providers/purchase_provider.dart';
import 'package:ilearn_papiamento/widgets/monthly_description.dart';
import 'package:ilearn_papiamento/widgets/yearly_description.dart.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class PremiumItems extends StatelessWidget {
  const PremiumItems({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return Consumer<PurchaseProvider>(
      builder: (context, provider, child) {
        bool isPurchased = provider.isPurchased([
          AppConfig.monthlyProductId,
          AppConfig.yearlyProductId,
        ]);
        // if (provider.categories.isEmpty) {
        //   return const Center(child: CircularProgressIndicator());
        // }
        print(
          "=========================================================$isPurchased",
        );

        return Padding(
          padding: const EdgeInsets.all(0),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 13,
            mainAxisSpacing: 13,
            children: [
              if (!isPurchased)
                GestureDetector(
                  onTap: () {
                    _showPurchaseSheet(
                      context,
                      AppConfig.monthlyProductId,
                      AppConfig.yearlyProductId,
                      Colors.blue,
                      provider,
                    );
                  },
                  child: Stack(
                    fit: StackFit.expand,

                    children: [
                      PremiumItemWidget(
                        categoryName: appLocalizations.removeads,
                        categoryImage: AppImages.removeads,
                        color: AppColors.removeAdColor,
                      ),
                      Container(
                        color: Colors.black.withValues(alpha: 0.3),
                        child: const Center(
                          child: Icon(Icons.lock, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              // Dictionary
              GestureDetector(
                onTap: () {
                  _showPurchaseSheet(
                    context,
                    AppConfig.monthlyProductId,
                    AppConfig.yearlyProductId,
                    Colors.blue,
                    provider,
                  );
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    PremiumItemWidget(
                      categoryName: appLocalizations.dictionary,
                      categoryImage: AppImages.dictionary,
                      color: AppColors.dictionaryColor,
                    ),
                    if (!isPurchased)
                      Container(
                        color: Colors.black.withValues(alpha: 0.3),
                        child: const Center(
                          child: Icon(Icons.lock, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPurchaseSheet(
    BuildContext context,
    String monthlyId,
    String yearlyId,
    Color color,
    PurchaseProvider provider,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (_) => SubscriptionOptions(
            provider: provider,
            monthlyProductId: monthlyId,
            yearlyProductId: yearlyId,
            // title: 'Unlock Premium Features',
            color: color,
          ),
    );
  }
}

class SubscriptionOptions extends StatefulWidget {
  final PurchaseProvider provider;
  final String monthlyProductId;
  final String yearlyProductId;
  final Color color;

  const SubscriptionOptions({
    super.key,
    required this.provider,
    required this.monthlyProductId,
    required this.yearlyProductId,
    required this.color,
  });

  @override
  State<SubscriptionOptions> createState() => _SubscriptionOptionsState();
}

class _SubscriptionOptionsState extends State<SubscriptionOptions> {
  bool isMonthly = true; // Used only when both options are available

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    // Safely find products using firstWhereOrNull
    final monthlyProduct = widget.provider.products.firstWhereOrNull(
      (p) => p.id == widget.monthlyProductId,
    );
    final yearlyProduct = widget.provider.products.firstWhereOrNull(
      (p) => p.id == widget.yearlyProductId,
    );

    // Check availability
    bool isMonthlyAvailable = monthlyProduct != null;
    bool isYearlyAvailable = yearlyProduct != null;
    bool bothAvailable = isMonthlyAvailable && isYearlyAvailable;

    // Determine the selected product
    ProductDetails? selectedProduct;
    if (bothAvailable) {
      selectedProduct = isMonthly ? monthlyProduct : yearlyProduct;
    } else if (isMonthlyAvailable) {
      selectedProduct = monthlyProduct;
    } else if (isYearlyAvailable) {
      selectedProduct = yearlyProduct;
    }

    // Build the list of available options
    List<Widget> options = [];
    if (isMonthlyAvailable) {
      Widget monthlyOption = PriceDetailContainer(
        per: "",
        type: appLocalizations.monthly,
        price: monthlyProduct.price,
        isSelected: bothAvailable ? isMonthly : true,
        color: widget.color,
      );
      options.add(
        bothAvailable
            ? GestureDetector(
              onTap: () => setState(() => isMonthly = true),
              child: monthlyOption,
            )
            : monthlyOption,
      );
    }
    if (isYearlyAvailable) {
      Widget yearlyOption = PriceDetailContainer(
        per: "",
        type: appLocalizations.yearly,
        price: yearlyProduct.price,
        isSelected: bothAvailable ? !isMonthly : true,
        color: widget.color,
      );
      options.add(
        bothAvailable
            ? GestureDetector(
              onTap: () => setState(() => isMonthly = false),
              child: yearlyOption,
            )
            : yearlyOption,
      );
    }

    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                appLocalizations.unlock_premium_features,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              if (options.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      options.length == 2
                          ? [options[0], const SizedBox(width: 10), options[1]]
                          : options,
                ),
                const SizedBox(height: 20),
                if (selectedProduct == monthlyProduct)
                  const MonthlyPremiumDescription()
                else if (selectedProduct == yearlyProduct)
                  const YearlyPremiumDescription(),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    if (selectedProduct != null) {
                      widget.provider.buyProduct(selectedProduct);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    child: Center(
                      child: Text(
                        appLocalizations.continuee,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ] else ...[
                Text(
                  appLocalizations.products_not_found,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// PriceDetailContainer Widget
class PriceDetailContainer extends StatelessWidget {
  final String type;
  final String price;
  final bool isSelected;
  final Color color;
  final String per;

  const PriceDetailContainer({
    super.key,
    required this.type,
    required this.price,
    required this.isSelected,
    required this.color,
    required this.per,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 110,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isSelected ? color : Colors.white,
        boxShadow: [
          BoxShadow(
            color:
                isSelected
                    ? Colors.transparent
                    : const Color.fromARGB(255, 216, 216, 216),
            blurRadius: 6,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        spacing: 20,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            type,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          FittedBox(
            child: Text(
              maxLines: 1,
              price,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Expanded(
          //   child: Text(
          //     'per $per',
          //     style: TextStyle(
          //       color: isSelected ? Colors.white : Colors.black,
          //       fontSize: 16,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

// Placeholder DictionaryPage
class DictionaryPage extends StatelessWidget {
  final Color color;
  const DictionaryPage({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dictionary')),
      body: Center(
        child: Text('Dictionary Page', style: TextStyle(color: color)),
      ),
    );
  }
}

// Placeholder HomeGridWidget
class PremiumItemWidget extends StatelessWidget {
  final Color color;
  final String categoryName;
  final String categoryImage;

  const PremiumItemWidget({
    super.key,
    required this.color,
    required this.categoryName,
    required this.categoryImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(flex: 2, child: Image.asset(categoryImage)),
          const SizedBox(height: 8),
          FittedBox(
            child: Text(
              // 'sdsds sdsd d',
              categoryName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                // fontFamily: AppConfig.avenir,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
