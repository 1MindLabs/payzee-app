import 'dart:developer';

import 'package:riverpod/riverpod.dart';
import 'package:upi_pay/features/auth/model/citizen_response.dart';
import 'package:upi_pay/features/auth/model/citizen_signup.dart';
import 'package:upi_pay/features/auth/service/auth_service.dart';

class CitizenNotifier extends StateNotifier<CitizenResponse?> {
  CitizenNotifier() : super(null);

  Future<void> citizenSignup(CitizenSignup citizen) async {
    try {
      log('In Citizen Notifier');
      log('Citizen data: ${citizen.toJson()}');
      CitizenResponse citizenResponse = await AuthService().signUp(citizen);
      state = citizenResponse;

      log('Citizen response: ${citizenResponse.toJson()}');
    } catch (e, stackTrace) {
      log('Error during citizen signup: $e');
      log('Stack trace: $stackTrace');
      // Optionally, handle the error state here if needed
    }
  }

  void clearCitizen() {
    state = null;
  }
}

final citizenProvider = StateNotifierProvider<CitizenNotifier, CitizenResponse?>(
  (ref) => CitizenNotifier(),
);