import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:upi_pay/features/user/dashboard/data/models/past_transaction.dart';

class PastTransactionTile extends StatelessWidget {
  final PastTransaction txn;
  const PastTransactionTile({required this.txn, super.key});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd MMM').format(txn.date);
    final amtStr = NumberFormat.simpleCurrency(
      locale: 'en_IN',
      name: '₹',
    ).format(txn.amount);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.black,
          child: Icon(Icons.receipt_long, color: Colors.white),
        ),
        title: Text(
          txn.merchant,
          style: GoogleFonts.roboto(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '${txn.utility} • $dateStr',
          style: GoogleFonts.roboto(fontSize: 12),
        ),
        trailing: Text(
          amtStr,
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}