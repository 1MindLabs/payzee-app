import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upi_pay/features/user/dashboard/data/models/user_profile.dart';
import 'package:upi_pay/features/user/dashboard/data/services/profile_service.dart';

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier()
    : super(
        UserProfile(
          userId: '0',
          allocatedAmt: 0,
          remainingAmt: 0,
          personalWallet: 0,
          govtWallet: 0,
        ),
      );

  Future<void> updateUserProfile(ProfileService profileService) async {
    UserProfile? userProfile = await profileService.fetchUserProfile();
    log('User profile fetched to provider: $userProfile');

    if (userProfile != null) {
      log('here');
      state = userProfile;
    } else {
      state = UserProfile(
        userId: '0',
        allocatedAmt: 0,
        remainingAmt: 0,
        personalWallet: 0,
        govtWallet: 0,
      );
    }
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile?>(
      (ref) => UserProfileNotifier(),
    );
