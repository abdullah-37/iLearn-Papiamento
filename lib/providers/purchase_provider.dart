import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// IAPProvider manages in-app purchases for consumables, non-consumables, and subscriptions,
/// with loading state support.
class IAPProvider with ChangeNotifier {
  final InAppPurchase _iap = InAppPurchase.instance;
  late final StreamSubscription<List<PurchaseDetails>> _subscription;

  // Loading states
  bool _isInitializing = false;
  bool _isLoadingProducts = false;
  bool _isPurchasing = false;

  bool get isInitializing => _isInitializing;
  bool get isLoadingProducts => _isLoadingProducts;
  bool get isPurchasing => _isPurchasing;

  bool _adsRemoved = false;
  bool get adsRemoved => _adsRemoved;

  /// Available products fetched from store
  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;

  /// Past purchases
  final List<PurchaseDetails> _purchases = [];
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
      _onPurchaseUpdated,
      onDone: () => _subscription.cancel(),
      onError: (error) => debugPrint('IAP Stream Error: $error'),
    );

    // Check store availability
    _isAvailable = await _iap.isAvailable();
    _isInitializing = false;
    notifyListeners();
  }

  /// Load products by their IDs
  Future<void> loadProducts(Set<String> productIds) async {
    _isLoadingProducts = true;
    notifyListeners();

    final response = await _iap.queryProductDetails(productIds);
    if (response.error != null) {
      debugPrint('Product query error: ${response.error}');
    } else {
      _products = response.productDetails;
    }

    _isLoadingProducts = false;
    notifyListeners();
  }

  /// Initiate purchase
  Future<void> buyProduct(
    ProductDetails product, {
    bool consumable = false,
  }) async {
    _isPurchasing = true;
    notifyListeners();

    try {
      final param = PurchaseParam(productDetails: product);
      if (consumable) {
        await _iap.buyConsumable(purchaseParam: param);
      } else {
        await _iap.buyNonConsumable(purchaseParam: param);
      }
    } catch (e) {
      debugPrint('Purchase error: $e');
    } finally {
      _isPurchasing = false;
      notifyListeners();
    }
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchasesList) {
    for (final purchase in purchasesList) {
      if (purchase.status == PurchaseStatus.purchased &&
          !purchase.pendingCompletePurchase) {
        if (purchase.productID == 'remove_ads') {
          _adsRemoved = true;
          notifyListeners();

          _iap.completePurchase(purchase);
        }
      }
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
