// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';

// /// IAPProvider manages in-app purchases for consumables, non-consumables, and subscriptions.
// class IAPProvider with ChangeNotifier {
//   final InAppPurchase _iap = InAppPurchase.instance;
//   late final StreamSubscription<List<PurchaseDetails>> _subscription;

//   /// Available products fetched from store
//   List<ProductDetails> _products = [];
//   List<ProductDetails> get products => _products;

//   /// Past purchases
//   final List<PurchaseDetails> _purchases = [];
//   List<PurchaseDetails> get purchases => _purchases;

//   bool _isAvailable = false;
//   bool get isAvailable => _isAvailable;

//   IAPProvider() {
//     _init();
//   }

//   Future<void> _init() async {
//     // Subscribe to purchase updates
//     _subscription = _iap.purchaseStream.listen(
//       _onPurchaseUpdated,
//       onDone: () => _subscription.cancel(),
//       onError: (error) => debugPrint('IAP Stream Error: $error'),
//     );
//     // Check availability
//     _isAvailable = await _iap.isAvailable();
//     if (_isAvailable) notifyListeners();
//   }

//   /// Load products by their IDs
//   Future<void> loadProducts(Set<String> productIds) async {
//     final response = await _iap.queryProductDetails(productIds);
//     if (response.error != null) {
//       debugPrint('Product query error: ${response.error}');
//     } else {
//       _products = response.productDetails;
//       notifyListeners();
//     }
//   }

//   /// Initiate purchase
//   Future<void> buyProduct(
//     ProductDetails product, {
//     bool consumable = false,
//   }) async {
//     try {
//       final param = PurchaseParam(productDetails: product);
//       if (consumable) {
//         await _iap.buyConsumable(purchaseParam: param);
//       } else {
//         await _iap.buyNonConsumable(purchaseParam: param);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   /// Handle purchase updates
//   Future<void> _onPurchaseUpdated(List<PurchaseDetails> list) async {
//     for (var purchase in list) {
//       if (purchase.status == PurchaseStatus.purchased ||
//           purchase.status == PurchaseStatus.restored) {
//         // TODO: Verify purchase on server if needed
//         if (purchase.pendingCompletePurchase) {
//           await _iap.completePurchase(purchase);
//         }
//         _purchases.add(purchase);
//       } else if (purchase.status == PurchaseStatus.error) {
//         debugPrint('Purchase error: ${purchase.error}');
//       }
//     }
//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
// }
