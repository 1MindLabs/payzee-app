import 'dart:convert';
import 'dart:developer';

import 'package:upi_pay/core/utils/base_url.dart';
import 'package:upi_pay/features/auth/model/citizen_response.dart';
import 'package:upi_pay/features/auth/model/citizen_signup.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<CitizenResponse> signUp(CitizenSignup citizen) async {
    final String url = '$baseUrl/api/v1/auth/signup/citizen';

    try {
      log('Sign up URL: $url');
      log('Citizen data in service: ${citizen.toJson()}');

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(citizen.toJson()),
      );
      log('Response body: ${response.body}');
      log('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        log('Response data: $responseData');
        return CitizenResponse.fromJson(responseData);
      } else {
        throw Exception('Failed to sign up: ${response.statusCode}');
      }
    } catch (e) {
      // log('Error during sign up: $e', stackTrace: stackTrace);
      throw Exception('An error occurred during sign up: $e');
    }
  }
}
