import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:ilearn_papiamento/config/images.dart';

const String removeAdsMonthlyId = 'buy_code_1';
const String removeAdsYearlyId = 'buy_code_3';
const String dictionaryMonthlyId = 'buy_code_4';
const String dictionaryYearlyId = 'buy_code_5';

class Category {
  final String name;
  final List<String> grantingProductIds;
  final String image;
  final Color color;

  Category({
    required this.name,
    required this.grantingProductIds,
    required this.color,
    required this.image,
  });
}

class PurchaseProvider with ChangeNotifier {
  final InAppPurchase _iap = InAppPurchase.instance;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  List<Category> _categories = [];
  bool _isRemoveAdsPurchased = false;

  PurchaseProvider() {
    _initialize();
    _iap.purchaseStream.listen((purchases) {
      _purchases = purchases;
      checkRemoveAdsPurchased();
      notifyListeners();
    });
  }

  Future<void> _initialize() async {
    await loadProducts();
    await restorePurchases();
    _setupCategories();
    checkRemoveAdsPurchased();
    notifyListeners();
  }

  //
  void checkRemoveAdsPurchased() {
    final bool isp = _purchases.any(
      (purchase) =>
          purchase.productID == removeAdsMonthlyId ||
          purchase.productID == removeAdsYearlyId &&
              purchase.status == PurchaseStatus.purchased,
    );
    if (isp) {
      _isRemoveAdsPurchased = true;
      notifyListeners();
    }
  }

  //
  Future<void> loadProducts() async {
    final bool available = await _iap.isAvailable();
    if (!available) return;
    const Set<String> ids = {
      removeAdsMonthlyId,
      removeAdsYearlyId,
      dictionaryMonthlyId,
      dictionaryYearlyId,
    };
    final ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    _products = response.productDetails;
    notifyListeners();
  }

  Future<void> restorePurchases() async {
    final bool available = await _iap.isAvailable();
    if (!available) return;
    await _iap.restorePurchases();
  }

  bool isPurchased(List<String> productIds) {
    return productIds.any(
      (id) => _purchases.any(
        (purchase) =>
            purchase.productID == id &&
            purchase.status == PurchaseStatus.purchased,
      ),
    );
  }

  Future<void> buyProduct(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  void _setupCategories() {
    _categories = [
      Category(
        name: 'Remove Ads',
        grantingProductIds: [removeAdsMonthlyId, removeAdsYearlyId],
        color: const Color.fromARGB(255, 188, 204, 16),
        image: AppImages.removeads,
      ),
      Category(
        name: 'Dictionary',
        grantingProductIds: [dictionaryMonthlyId, dictionaryYearlyId],
        color: const Color.fromARGB(255, 1, 163, 131),
        image: AppImages.dictionary,
      ),
    ];
  }

  // Getters
  List<Category> get categories => _categories;
  List<ProductDetails> get products => _products;
  bool get isRemoveAdsPurchased => _isRemoveAdsPurchased;
}
