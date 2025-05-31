import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:upi_pay/core/utils/base_url.dart';
import 'package:upi_pay/features/user/dashboard/data/models/scheme.dart';
import 'package:http/http.dart' as http;

class SchemeService {
  Future<List<SchemeModel>> getScheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? citizenId = prefs.getString('citizenId');
    String url =
        '$baseUrl/api/v1/citizens/$citizenId/eligible-schemes';
    log('In scheme service: $url');
    final response = await http.get(Uri.parse(url));
    log('In scheme service: ${response.body}');
    if (response.statusCode == 200) {
      List<dynamic> schemesJson = jsonDecode(response.body);
      return schemesJson.map((json) => SchemeModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load schemes');
    }
  }
}
