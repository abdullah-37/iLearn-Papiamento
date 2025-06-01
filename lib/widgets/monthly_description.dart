import 'package:flutter/material.dart';
import 'package:ilearn_papiamento/l10n/app_localizations.dart';

class MonthlyPremiumDescription extends StatelessWidget {
  const MonthlyPremiumDescription({super.key});

  Widget _buildRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2.0),
          child: Icon(Icons.check, color: Colors.green, size: 20),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRow(appLocalizations.description1m),
        const SizedBox(height: 6),
        _buildRow(appLocalizations.description2),
        const SizedBox(height: 6),
        _buildRow(appLocalizations.description3),
        const SizedBox(height: 6),
        _buildRow(appLocalizations.description4),
      ],
    );
  }
}
