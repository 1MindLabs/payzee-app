import 'package:shared_preferences/shared_preferences.dart';
import 'package:upi_pay/core/utils/base_url.dart';
import 'package:upi_pay/features/user/dashboard/data/models/citizen_transaction.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CitizenTransactionService {
  Future<List<CitizenTransaction>> getCitizenTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? citizenId = prefs.getString('citizenId');
    final apiUrl =
        '$baseUrl/api/v1/citizens/$citizenId/transactions';
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => CitizenTransaction.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      throw Exception('Error fetching transactions: $e');
    }
  }
}
