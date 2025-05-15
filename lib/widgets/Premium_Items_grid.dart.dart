import 'package:flutter/material.dart';
import 'package:ilearn_papiamento/config/app_colors.dart';
import 'package:ilearn_papiamento/providers/fetch_data_provider.dart';
import 'package:ilearn_papiamento/providers/purchase_provider.dart';
import 'package:ilearn_papiamento/views/dictionary_view.dart';
import 'package:ilearn_papiamento/widgets/home_grid_widget.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

class PremiumItems extends StatefulWidget {
  const PremiumItems({super.key});

  @override
  State<PremiumItems> createState() => _PremiumItemsState();
}

class _PremiumItemsState extends State<PremiumItems> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ids =
          context
              .read<FetchDataProvider>()
              .premiumFeaturesData!
              .categories!
              .map((c) => c.productId)
              .where((id) => id != null && id.isNotEmpty)
              .cast<String>()
              .toSet();
      context.read<IAPProvider>().loadProducts(ids);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fetchProvider = context.watch<FetchDataProvider>();
    final categories = fetchProvider.premiumFeaturesData?.categories ?? [];

    return Consumer<IAPProvider>(
      builder: (context, iap, child) {
        print("cccccccccccccccc$categories");
        // Load products dynamically when categories are ready
        // if (categories.isNotEmpty &&
        //     iap.products.isEmpty &&
        //     !iap.isLoadingProducts) {

        // }

        if (iap.isInitializing || iap.isLoadingProducts) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!iap.isAvailable) {
          return const Center(child: Text('Store not available'));
        }
        if (categories.isEmpty) {
          return const Center(
            child: Text(
              'No premium items available',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 13,
              mainAxisSpacing: 13,
            ),
            itemBuilder: (context, index) {
              final premiumItem = categories[index];
              final productId = premiumItem.productId;

              if (productId == null || productId.isEmpty) {
                return const SizedBox.shrink(); // Skip items without valid productId
              }

              final product = iap.products.firstWhere((p) => p.id == productId);

              final purchased = iap.purchases.any(
                (p) =>
                    p.productID == productId &&
                    p.status == PurchaseStatus.purchased,
              );

              return GestureDetector(
                onTap: () {
                  if (purchased) {
                    if (premiumItem.productId == "buy_code_3") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => DictionaryPage(
                                color: Color(
                                  int.parse(
                                    "FF${premiumItem.color}",
                                    radix: 16,
                                  ),
                                ),
                              ),
                        ),
                      );
                    }
                  } else {
                    if (premiumItem.productId == "buy_code_3") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => DictionaryPage(
                                color: Color(
                                  int.parse(
                                    "FF${premiumItem.color}",
                                    radix: 16,
                                  ),
                                ),
                              ),
                        ),
                      );
                    } else {
                      _showPurchaseSheet(context, product, iap);
                    }
                  }
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // HomeGridWidget(category: premiumItem),
                    HomeGridWidget(category: premiumItem),
                    if (!purchased)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black45,
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
            },
          ),
        );
      },
    );
  }

  void _showPurchaseSheet(
    BuildContext context,
    ProductDetails product,
    IAPProvider iap,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.appBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (_) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  product.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  'Price: ${product.price}',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 24),
                iap.isPurchasing
                    ? const CircularProgressIndicator()
                    : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blue, // Button background color
                          foregroundColor: Colors.white, // Text/icon color
                          elevation: 5, // Shadow depth
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              12,
                            ), // Rounded corners
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          iap.buyProduct(product, consumable: false);
                        },
                        child: const Text('Buy Now'),
                      ),
                    ),
                const SizedBox(height: 12),
              ],
            ),
          ),
    );
  }
}
