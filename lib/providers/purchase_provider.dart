import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// Manages in-app purchases with dynamic product loading and state management.
class IAPProvider with ChangeNotifier {
  final InAppPurchase _iap = InAppPurchase.instance;
  late final StreamSubscription<List<PurchaseDetails>> _subscription;

  // Loading states
  bool _isInitializing = false;
  bool _isLoadingProducts = false;
  bool _isPurchasing = false;
  bool _adsRemoved = false;
  bool get adsRemoved => _adsRemoved;

  bool get isInitializing => _isInitializing;
  bool get isLoadingProducts => _isLoadingProducts;
  bool get isPurchasing => _isPurchasing;

  /// Available products fetched from store
  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;

  /// Past and current purchases
  List<PurchaseDetails> _purchases = [];
  List<PurchaseDetails> get purchases => _purchases;

  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;

  IAPProvider() {
    _init();
  }

  Future<void> _init() async {
    _isInitializing = true;
    notifyListeners();

    // Subscribe to purchase updates
    _subscription = _iap.purchaseStream.listen(
      (purchases) {
        _purchases = purchases;
        _updateAdsRemoved(); // ← check here

        notifyListeners(); // Ensure UI updates on purchase changes
      },
      onDone: () => _subscription.cancel(),
      onError: (error) => debugPrint('IAP Stream Error: $error'),
    );

    _isAvailable = await _iap.isAvailable();
    if (_isAvailable) {
      // 3. Query past (restored) purchases
      await _iap.restorePurchases();
    }
    _isInitializing = false;
    notifyListeners();
  }

  /// Load products dynamically by their IDs
  Future<void> loadProducts(Set<String> productIds) async {
    if (productIds.isEmpty) {
      debugPrint('No valid product IDs to load');
      return;
    }

    _isLoadingProducts = true;
    notifyListeners();

    final response = await _iap.queryProductDetails(productIds);
    if (response.error != null) {
      debugPrint('Product query error: ${response.error}');
      _products = [];
    } else {
      _products = response.productDetails;
      if (_products.isNotEmpty) {
        debugPrint('Loaded products: ${_products.map((p) => p.id).join(', ')}');
      }
    }

    _isLoadingProducts = false;
    notifyListeners();
  }

  /// Initiate a purchase
  Future<void> buyProduct(
    ProductDetails product, {
    bool consumable = false,
  }) async {
    _isPurchasing = true;
    notifyListeners();

    try {
      final param = PurchaseParam(productDetails: product);
      bool success =
          consumable
              ? await _iap.buyConsumable(purchaseParam: param)
              : await _iap.buyNonConsumable(purchaseParam: param);
      if (success) {
        _verifyPurchase(product.id);
      }
    } catch (e) {
      debugPrint('Purchase error: $e');
    } finally {
      _isPurchasing = false;
      notifyListeners();
    }
  }

  /// Verify and complete purchases
  void _verifyPurchase(String productId) {
    for (final purchase in _purchases) {
      if (purchase.productID == productId &&
          purchase.status == PurchaseStatus.purchased &&
          !purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
        debugPrint('Purchase completed for product: $productId');
      }
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  /// Call this whenever _purchases changes (stream, restore, etc.)
  void _updateAdsRemoved() {
    // Replace 'remove_ads' with your actual product ID
    // _adsRemoved = true;
    _adsRemoved = _purchases.any(
      (p) =>
          p.productID == 'remove_ads' && p.status == PurchaseStatus.purchased,
    );
  }

  /// Public method if you ever need to manually re-check (e.g. on app start)
  void checkAdsRemoved() {
    _updateAdsRemoved();
    notifyListeners();
  }
}
