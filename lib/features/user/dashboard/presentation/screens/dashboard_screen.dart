import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:upi_pay/features/user/dashboard/data/mock/transaction_history.dart';
import 'package:upi_pay/features/user/dashboard/data/mock/utility_cards.dart';
import 'package:upi_pay/features/user/dashboard/presentation/widgets/choose_payment_option_bottom_sheet.dart';
import 'package:upi_pay/features/user/dashboard/presentation/widgets/confetti_card.dart';
import 'package:upi_pay/features/user/dashboard/presentation/widgets/past_transaction_tile.dart';
import 'package:upi_pay/features/user/dashboard/presentation/widgets/wallet_functions.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('My eRupee Wallet', style: GoogleFonts.roboto()),
        actions: [
          IconButton(
            icon: Icon(Icons.volume_up, color: Colors.black),
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
                        'Total Allocated',
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
                        'Total Remaining',
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
            height: 100,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WalletFunctions(icon: Icons.money, title: 'Send'),
                  WalletFunctions(
                    icon: Icons.generating_tokens_rounded,
                    title: 'Collect',
                  ),
                  WalletFunctions(
                    icon: Icons.account_balance_wallet,
                    title: 'Load',
                  ),
                  WalletFunctions(
                    icon: Icons.account_balance_wallet,
                    title: 'Redeem',
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
                'Past Transactions',
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
        label: Text('Payment'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
