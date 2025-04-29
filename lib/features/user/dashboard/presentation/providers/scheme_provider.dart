import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:upi_pay/features/user/dashboard/data/models/scheme.dart';

class SchemeNotifier extends StateNotifier<List<SchemeModel>> {
  SchemeNotifier() : super([]);

  Future<void> fetchSchemes() async {
    final response = await http.get(
      Uri.parse(
        'http://192.168.215.94:8000/api/v1/user/eligible-schemes?user_id=eLuQDhF68Nbw7znZlo75',
      ),
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body) as List;
      state =
          data
              .map((e) => SchemeModel.fromJson(e as Map<String, dynamic>))
              .toList();
    }
  }
}

final schemeNotifierProvider =
    StateNotifierProvider<SchemeNotifier, List<SchemeModel>>(
  (ref) => SchemeNotifier(),
);