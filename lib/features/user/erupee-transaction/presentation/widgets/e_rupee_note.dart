import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:upi_pay/features/user/erupee-transaction/data/mock/erupee_notes.dart';

class ERupeeNote extends StatelessWidget {
  final int idx;
  const ERupeeNote({super.key, required this.idx});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Image(image: AssetImage(eRupeeNotes[idx]), fit: BoxFit.fitWidth),
    );
  }
}
