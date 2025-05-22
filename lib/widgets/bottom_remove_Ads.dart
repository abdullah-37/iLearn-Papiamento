// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:ilearn_papiamento/providers/purchase_provider.dart';
// import 'package:provider/provider.dart';

// /// Call this to show a Material-style bottom sheet for “Remove Ads”
// void showRemoveAdsBottomSheet(
//   BuildContext context, {
//   Color backgroundColor = Colors.white,
//   Color titleColor = Colors.black,
//   Color messageColor = Colors.grey,
//   Color actionTextColor = Colors.blue,
//   Color cancelTextColor = Colors.red,
// }) {
//   showModalBottomSheet<void>(
//     context: context,
//     backgroundColor: backgroundColor,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//     ),
//     builder: (BuildContext ctx) {
//       AppLocalizations appLocalizations = AppLocalizations.of(context)!;
//       // final iap = Provider.of<IAPProvider>(context, listen: true);

//       return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Drag handle
//             Container(
//               width: 40,
//               height: 4,
//               margin: const EdgeInsets.only(bottom: 16),
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),

//             // Title
//             Text(
//               appLocalizations.removeads,
//               style: TextStyle(
//                 color: titleColor,
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),

//             const SizedBox(height: 8),

//             // Message
//             // Text(
//             //   appLocalizations.get_ad_free_experience_for,
//             //   style: TextStyle(color: messageColor, fontSize: 16),
//             //   textAlign: TextAlign.center,
//             // ),
//             const SizedBox(height: 24),

//             // Buy button
//             PayButton(appLocalizations: appLocalizations),

//             // const SizedBox(height: 12),

//             // Cancel button
//             SizedBox(
//               width: double.infinity,
//               child: TextButton(
//                 onPressed: () => Navigator.pop(ctx),
//                 child: Text(
//                   'Cancel',
//                   style: TextStyle(fontSize: 16, color: cancelTextColor),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 8),
//           ],
//         ),
//       );
//     },
//   );
// }

// class PayButton extends StatelessWidget {
//   const PayButton({super.key, required this.appLocalizations});

//   final AppLocalizations appLocalizations;

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<IAPProvider>(
//       builder:
//           (context, iap, _) =>
//               iap.products.isEmpty
//                   ? const Text(
//                     'No Products Available',
//                     style: TextStyle(color: Colors.white),
//                   )
//                   : Expanded(
//                     child: ListView.builder(
//                       itemCount: iap.products.length,
//                       itemBuilder: (context, index) {
//                         final product = iap.products[index];
//                         final productId = product.id;
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 5.0),
//                           child: SizedBox(
//                             width: double.infinity,
//                             height: 50,
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 // primary: actionTextColor.withOpacity(0.1),
//                                 // onPrimary: actionTextColor,
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 14,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                               onPressed: () {
//                                 try {
//                                   final product = iap.products.firstWhere(
//                                     (p) => p.id == productId,
//                                     orElse: () => throw "Product not found",
//                                   );

//                                   iap.buyProduct(product, consumable: false);
//                                 } catch (e) {
//                                   Navigator.pop(context);

//                                   ScaffoldMessenger.of(
//                                     context,
//                                   ).showSnackBar(SnackBar(content: Text('$e')));
//                                   print(e);
//                                 }
//                               },
//                               child:
//                                   iap.isPurchasing
//                                       ? const SizedBox(
//                                         width: 24,
//                                         height: 24,
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 2,
//                                           color:
//                                               Colors
//                                                   .black, // match your button’s onPrimary
//                                         ),
//                                       )
//                                       : Text(
//                                         '${product.price} ',
//                                         style: const TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.green,
//                                         ),
//                                       ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//     );
//   }
// }
