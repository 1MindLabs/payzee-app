import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
extension LocalizationHelpers on AppLocalizations {
  String translateUtilityName(String key, BuildContext context) {
    switch (key) {
      case 'govtSubsidyWallet':
        return AppLocalizations.of(context)!.govtSubsidyWallet;
      case 'personalERupeeWallet':
        return AppLocalizations.of(context)!.personalERupeeWallet;
      default:
        return key; // fallback
    }
  }
}