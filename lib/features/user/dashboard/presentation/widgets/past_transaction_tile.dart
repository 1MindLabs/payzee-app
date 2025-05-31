import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:upi_pay/features/user/dashboard/data/models/citizen_transaction.dart';

class PastTransactionTile extends StatelessWidget {
  final CitizenTransaction txn;

  const PastTransactionTile({
    super.key,
    required this.txn,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd MMM').format(txn.timestamp);
    final amtStr = NumberFormat.simpleCurrency(
      locale: 'en_IN',
      name: '₹',
    ).format(txn.amount);

    // Determine direction and color

    final Color amountColor = txn.txType == 'government-to-citizen' ? Colors.green : Colors.red;
    final IconData icon = txn.txType == 'government-to-citizen' ? Icons.call_received : Icons.call_made;
    final String typeLabel = txn.txType == 'government-to-citizen'
        ? 'Govt Transfer'
        : 'Purchase';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: txn.txType == 'government-to-citizen' ? Colors.green : Colors.red,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          txn.description,
          style: GoogleFonts.roboto(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '$typeLabel • $dateStr',
          style: GoogleFonts.roboto(fontSize: 12),
        ),
        trailing: Text(
          txn.txType == 'government-to-citizen' ? '+$amtStr' : '-$amtStr',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            color: amountColor,
          ),
        ),
      ),
    );
  }
}
