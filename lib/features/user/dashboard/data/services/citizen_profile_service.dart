import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upi_pay/core/utils/base_url.dart';
import 'package:upi_pay/features/user/dashboard/data/models/citizen_profile.dart';

class CitizenProfileService {
  Future<CitizenProfile> fetchCitizenProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? citizenId = prefs.getString('citizenId');
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/citizens/$citizenId'),
    );
    log('citizen profile url: $baseUrl/api/v1/citizens/$citizenId');
    log('In citizen service: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return CitizenProfile.fromJson(jsonData);
    } else {
      throw Exception('Failed to load user profile');
    }
  }
}
