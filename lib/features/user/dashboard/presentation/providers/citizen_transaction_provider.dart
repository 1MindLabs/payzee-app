import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upi_pay/features/user/dashboard/data/models/citizen_transaction.dart';
import 'package:upi_pay/features/user/dashboard/data/services/citizen_transaction_service.dart';

class CitizenTransactionNotifier extends StateNotifier<List<CitizenTransaction>> {
  CitizenTransactionNotifier() : super([]);

  Future<bool> getCitizenTransaction() async {
    try {
      final transactions = await CitizenTransactionService().getCitizenTransactions();
      state = transactions;
      return true;
    } catch (e) {
      log('Error fetching citizen transactions: $e');
      return false;
    }
  }

  void clearCitizenTransactions() {
    state = [];
  }
}


final citizenTransactionProvider = StateNotifierProvider<CitizenTransactionNotifier, List<CitizenTransaction>>(
  (ref) => CitizenTransactionNotifier(),
);