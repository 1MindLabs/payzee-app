import 'package:flutter/material.dart';
import 'package:upi_pay/features/user/qr-scanner/presentation/screen/qr_scanner_screen.dart';
import 'package:upi_pay/features/user/vendor-id/presentation/screen/vendor_id_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showPaymentOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.choosePaymentMethod,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.qr_code_scanner, size: 30),
              title: Text(AppLocalizations.of(context)!.scanQRCode),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => QrScannerScreen(),
                ));
              },
            ),
            ListTile(
              leading: Icon(Icons.account_balance_wallet, size: 30),
              title: Text(AppLocalizations.of(context)!.payViaAccountId),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => VendorOrIdScreen(),
                ));
              },
            ),
          ],
        ),
      );
    },
  );
}
