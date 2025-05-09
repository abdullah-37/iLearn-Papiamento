import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Call this to show a Material-style bottom sheet for “Remove Ads”
void showRemoveAdsBottomSheet(
  BuildContext context, {
  Color backgroundColor = Colors.white,
  Color titleColor = Colors.black,
  Color messageColor = Colors.grey,
  Color actionTextColor = Colors.blue,
  Color cancelTextColor = Colors.red,
}) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: backgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext ctx) {
      AppLocalizations appLocalizations = AppLocalizations.of(context)!;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Text(
              appLocalizations.removeads,
              style: TextStyle(
                color: titleColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            // Message
            Text(
              '${appLocalizations.get_ad_free_experience_for} \$300',
              style: TextStyle(color: messageColor, fontSize: 16),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Buy button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // primary: actionTextColor.withOpacity(0.1),
                  // onPrimary: actionTextColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  // TODO: trigger your purchase flow here
                },
                child: Text(
                  '${appLocalizations.buy_for} \$300',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: actionTextColor,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Cancel button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16, color: cancelTextColor),
                ),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}
