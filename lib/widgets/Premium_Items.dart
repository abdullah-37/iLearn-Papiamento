// PremiumItems Widget
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:ilearn_papiamento/providers/purchase_provider.dart';
import 'package:provider/provider.dart';

class PremiumItems extends StatelessWidget {
  const PremiumItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PurchaseProvider>(
      builder: (context, provider, child) {
        if (provider.categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(0),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 13,
            mainAxisSpacing: 13,
            children:
                provider.categories.map((category) {
                  final isPurchased = provider.isPurchased(
                    category.grantingProductIds,
                  );
                  return GestureDetector(
                    onTap: () {
                      if (isPurchased) {
                        if (category.name == 'Dictionary') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      const DictionaryPage(color: Colors.blue),
                            ),
                          );
                        }
                        // For "Remove Ads", no action needed as ads are removed
                      } else {
                        _showPurchaseSheet(
                          context,
                          category,
                          category.color,
                          provider,
                        );
                      }
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        PremiumItemWidget(category: category),
                        if (!isPurchased)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black45.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.lock,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        );
      },
    );
  }

  void _showPurchaseSheet(
    BuildContext context,
    Category category,
    Color color,
    PurchaseProvider provider,
  ) {
    String monthlyId;
    String yearlyId;
    String title;

    if (category.name == 'Remove Ads') {
      monthlyId = removeAdsMonthlyId;
      yearlyId = removeAdsYearlyId;
      title = 'Remove Ads';
    } else if (category.name == 'Dictionary') {
      monthlyId = dictionaryMonthlyId;
      yearlyId = dictionaryYearlyId;
      title = 'Unlock Dictionary';
    } else {
      return; // Unknown category
    }

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
            title: title,
            color: color,
          ),
    );
  }
}

class SubscriptionOptions extends StatefulWidget {
  final PurchaseProvider provider;
  final String monthlyProductId;
  final String yearlyProductId;
  final String title;
  final Color color;

  const SubscriptionOptions({
    super.key,
    required this.provider,
    required this.monthlyProductId,
    required this.yearlyProductId,
    required this.title,
    required this.color,
  });

  @override
  State<SubscriptionOptions> createState() => _SubscriptionOptionsState();
}

class _SubscriptionOptionsState extends State<SubscriptionOptions> {
  bool isMonthly = true;

  @override
  Widget build(BuildContext context) {
    final monthlyProduct = widget.provider.products.firstWhere(
      (p) => p.id == widget.monthlyProductId,
      orElse: () => throw Exception('Monthly product not found'),
    );
    final yearlyProduct = widget.provider.products.firstWhere(
      (p) => p.id == widget.yearlyProductId,
      orElse: () => throw Exception('Yearly product not found'),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => setState(() => isMonthly = true),
                child: PriceDetailContainer(
                  per: "month",
                  type: "MONTHLY",
                  price: monthlyProduct.price,
                  isSelected: isMonthly,
                  color: widget.color,
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () => setState(() => isMonthly = false),
                child: PriceDetailContainer(
                  type: "YEARLY",
                  per: "year",
                  price: yearlyProduct.price,
                  isSelected: !isMonthly,
                  color: widget.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () {
              final selectedProduct =
                  isMonthly ? monthlyProduct : yearlyProduct;
              widget.provider.buyProduct(selectedProduct);
            },
            child: Container(
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: const Center(
                child: Text(
                  'Continue',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
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
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              type,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
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
          Expanded(
            child: Text(
              'per $per',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
  final Category category;

  const PremiumItemWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: category.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(flex: 2, child: Image.asset(category.image)),
          const SizedBox(height: 8),
          FittedBox(
            child: Text(
              // 'sdsds sdsd d',
              category.name,
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
