import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upi_pay/features/user/dashboard/data/models/citizen_profile.dart';
import 'package:upi_pay/features/user/dashboard/data/services/citizen_profile_service.dart';

class CitizenProfileNotifier extends StateNotifier<CitizenProfile> {
  CitizenProfileNotifier() : super(CitizenProfile.empty());

  Future<void> getCitizenProfile() async {
    CitizenProfile response =
        await CitizenProfileService().fetchCitizenProfile();
    state = response;
  }
}

final citizenProfileProvider = StateNotifierProvider<CitizenProfileNotifier, CitizenProfile>(
  (ref) => CitizenProfileNotifier(),
);
