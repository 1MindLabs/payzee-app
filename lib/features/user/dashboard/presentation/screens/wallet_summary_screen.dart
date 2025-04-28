import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upi_pay/features/user/dashboard/data/mock/utility_cards.dart';
import 'package:upi_pay/features/user/dashboard/data/models/utility_card.dart';

class WalletSummaryScreen extends ConsumerStatefulWidget {
  final int idx;
  const WalletSummaryScreen({super.key, required this.idx});

  @override
  ConsumerState<WalletSummaryScreen> createState() =>
      _WalletSummaryScreenState();
}

class _WalletSummaryScreenState extends ConsumerState<WalletSummaryScreen> {
  UtilityCard get utilityCard => utilityCards[widget.idx];

  String? selectedScheme;
  double? selectedBalance;

  bool get isPersonalWallet => widget.idx == 1;

  List<int> noteDenominations = [2000, 500, 200, 100, 50, 20, 10];

  List<int> calculateNotes(double balance) {
    List<int> notes = [];
    int amount = balance.round();
    for (int denom in noteDenominations) {
      while (amount >= denom) {
        notes.add(denom);
        amount -= denom;
      }
    }
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    final balanceToShow = selectedScheme != null ? selectedBalance : utilityCard.remaining;
    final notes = balanceToShow != null ? calculateNotes(balanceToShow) : [];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Wallet',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  utilityCard.cardName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Balance: ₹${utilityCard.remaining.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 20),
            
                if (widget.idx == 0) // Schemes Wallet
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Schemes',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: utilityCard.schemes!.entries.map((entry) {
                          return OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              side: BorderSide(color: Colors.black12),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                selectedScheme = entry.key;
                                selectedBalance = entry.value;
                              });
                            },
                            child: Text(entry.key),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
            
                      if (selectedScheme != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedScheme!,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '₹${selectedBalance?.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Colors.green,
                                  ),
                            ),
                            const SizedBox(height: 20),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: 2, // For demo purpose; replace with actual data
                              itemBuilder: (context, index) {
                                final collections = [
                                  {'icon': Icons.rice_bowl, 'name': 'Rice', 'amount': 200},
                                  {'icon': Icons.grass, 'name': 'Wheat', 'amount': 200},
                                ];
                                final item = collections[index];
                                return Card(
                                  elevation: 0,
                                  color: Colors.white,
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.black,
                                      child: Icon(item['icon'] as IconData, color: Colors.white),
                                    ),
                                    title: Text(item['name'] as String, style: TextStyle(fontWeight: FontWeight.bold)),
                                    trailing: Text('₹${item['amount']}'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
            
                if (isPersonalWallet) // Personal Wallet
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 400,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            for (int i = 0; i < notes.length; i++)
                              Positioned(
                                top: i * 20.0,
                                left: i * 20.0,
                                child: Image.asset(
                                  'assets/${notes[i]}-rupee.png', // example: assets/500-rupee.png
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
