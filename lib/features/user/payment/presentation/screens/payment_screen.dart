import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upi_pay/core/provider/erupee_provider.dart';
import 'package:upi_pay/features/user/payment/data/model/payment_card.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  List<PaymentCard> cards = [
    PaymentCard(name: "Government Subsidy Card", balance: 5000, id: "GOV1234"),
    PaymentCard(name: "Personal eWallet Card", balance: 1200, id: "PERS5678"),
  ];

  late PaymentCard selectedCard;
  String vendorId = "VEND-90876";
  String vendorLocation = "Mumbai, India";

  @override
  void initState() {
    super.initState();
    selectedCard = cards[0];
  }

  @override
  Widget build(BuildContext context) {
    double amountToPay = ref.watch(eruppeProvider); // in eRupee
    void _validateAndPay() {
      if (amountToPay > selectedCard.balance) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❗ Insufficient balance!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "✅ Paid ₹${amountToPay.toStringAsFixed(2)} eRupee via ${selectedCard.name}!",
            ),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('eRupee Pay', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Card",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            const SizedBox(height: 10),

            // Swipeable cards
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: cards.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final card = cards[index];
                  bool isSelected = card == selectedCard;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCard = card;
                      });
                    },
                    child: Container(
                      width: 250,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                        border:
                            isSelected
                                ? Border.all(color: Colors.blueAccent, width: 2)
                                : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            card.name,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "Balance: ₹${card.balance.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Contact Info (you can later make it editable)
            ListTile(
              leading: const Icon(Icons.person, color: Colors.black),
              title: const Text(
                "Contact",
                style: TextStyle(color: Colors.black),
              ),
              subtitle: const Text(
                "rigoel@icloud.com\n(810) 555-1009",
                style: TextStyle(color: Colors.black87),
              ),
            ),
            const Divider(color: Colors.black12),

            // Vendor Info
            ListTile(
              leading: const Icon(Icons.store, color: Colors.black),
              title: const Text(
                "Vendor Details",
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                "ID: $vendorId\nLocation: $vendorLocation",
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const Divider(color: Colors.white24),

            // Method
            ListTile(
              leading: const Icon(Icons.delivery_dining, color: Colors.black),
              title: const Text(
                "Method",
                style: TextStyle(color: Colors.black),
              ),
              subtitle: const Text(
                "Instant Payment",
                style: TextStyle(color: Colors.black54),
              ),
            ),

            const Spacer(),

            // Payment row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Pay",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                Text(
                  "₹${amountToPay.toStringAsFixed(2)} eRupee",
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Pay Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _validateAndPay,
              child: const Text("Pay Now"),
            ),
          ],
        ),
      ),
    );
  }
}

// Model Class
// class PaymentCard {
//   final String name;
//   final double balance;
//   final String id;

//   PaymentCard({required this.name, required this.balance, required this.id});
// }
