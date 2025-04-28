import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:upi_pay/core/provider/locale_provider.dart';
import 'package:upi_pay/features/user/dashboard/data/mock/transaction_history.dart';
import 'package:upi_pay/features/user/dashboard/data/mock/utility_cards.dart';
import 'package:upi_pay/features/user/dashboard/presentation/screens/map_screen.dart';
import 'package:upi_pay/features/user/dashboard/presentation/widgets/choose_payment_option_bottom_sheet.dart';
import 'package:upi_pay/features/user/dashboard/presentation/widgets/confetti_card.dart';
import 'package:upi_pay/features/user/dashboard/presentation/widgets/language_menu.dart';
import 'package:upi_pay/features/user/dashboard/presentation/widgets/past_transaction_tile.dart';
import 'package:upi_pay/features/user/dashboard/presentation/widgets/wallet_functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final totalAllocated = utilityCards.fold<double>(
      0,
      (sum, c) => sum + c.allocated,
    );
    final totalRemaining = utilityCards.fold<double>(
      0,
      (sum, c) => sum + c.remaining,
    );
    final fmt = NumberFormat.simpleCurrency(locale: 'en_IN', name: '₹');

    final locale = ref.watch(localeProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.appTitle,
          style: GoogleFonts.roboto(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.black),
            onPressed: () {
              // TTS for this card
            },
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 220,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.85),
              itemCount: utilityCards.length,
              itemBuilder: (_, i) => ConfettiCard(card: utilityCards[i]),
            ),
          ),

          const SizedBox(height: 16),

          Container(
            width: MediaQuery.of(context).size.width * 0.92,
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.totalAllocated,
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        fmt.format(totalAllocated),
                        style: GoogleFonts.roboto(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.totalRemaining,
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        fmt.format(totalRemaining),
                        style: GoogleFonts.roboto(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.92,
            height: locale == Locale('kn') ? 130 : 100,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: ()=> Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const MapScreen(),
                    )),
                    child: WalletFunctions(
                      icon: Icons.pin_drop_rounded,
                      title: AppLocalizations.of(context)!.map,
                    ),
                  ),
                  WalletFunctions(
                    icon: Icons.generating_tokens_rounded,
                    title: AppLocalizations.of(context)!.collect,
                  ),
                  WalletFunctions(
                    icon: Icons.account_balance_wallet,
                    title: AppLocalizations.of(context)!.load,
                  ),
                  GestureDetector(
                    onTap:
                        () => showModalBottomSheet(
                          context: context,
                          builder: (context) => const LanguageSelectionSheet(),
                        ),
                    child: WalletFunctions(
                      icon: Icons.sort_by_alpha,
                      title: AppLocalizations.of(context)!.language,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.pastTransactions,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: pastTransactions.length,
              itemBuilder:
                  (_, i) => PastTransactionTile(txn: pastTransactions[i]),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        onPressed: () {
          showPaymentOptions(context);
        },
        icon: Icon(Icons.payment),
        label: Text(AppLocalizations.of(context)!.payment),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
