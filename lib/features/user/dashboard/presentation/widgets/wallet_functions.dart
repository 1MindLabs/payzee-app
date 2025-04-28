import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upi_pay/core/provider/locale_provider.dart';

class WalletFunctions extends ConsumerWidget {
  final IconData icon;
  final String title;
  const WalletFunctions({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return SizedBox(
      width: 80,
      height: locale == Locale('kn') ? 105 : 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black),
            child: Icon(icon, size: 30, color: Colors.white),
          ),

          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
        ],
      ),
    );
  }
}
