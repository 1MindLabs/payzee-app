import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:upi_pay/features/user/dashboard/data/models/user_profile.dart';


class ProfileService {
  final String baseUrl = 'http://192.168.34.94:8000/api/v1/user/balance/eLuQDhF68Nbw7znZlo75';

  Future<UserProfile?> fetchUserProfile() async {
    try{
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        UserProfile userProfile = UserProfile.fromJson(data);
        log('User ID: ${userProfile.userId}');
        log('User profile fetched successfully: ${response.body}');

        return userProfile;
      } else {
        log('Failed to fetch user profile: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('Error fetching user profile: $e');
      return null;
    }
  }
}
