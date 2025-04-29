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
            password: '',
            accountInfo: AccountInfo(
              phoneNumber: '',
              dateCreated: '',
              address: '',
              email: '',
              fullName: '',
              username: '',
              aadhaarNumber: '',
            ),
            pastTransactions: [],
          ),
        );

  Future<void> updateUserProfile(ProfileService profileService) async {
    try {
      UserProfile? userProfile = await profileService.fetchUserProfile();
      log('User profile fetched to provider: ${userProfile?.toJson()}');

      if (userProfile != null) {
        state = userProfile;
      } else {
        state = UserProfile(
          userId: '0',
          allocatedAmt: 0,
          remainingAmt: 0,
          personalWallet: 0,
          govtWallet: 0,
          password: '',
          accountInfo: AccountInfo(
            phoneNumber: '',
            dateCreated: '',
            address: '',
            email: '',
            fullName: '',
            username: '',
            aadhaarNumber: '',
          ),
          pastTransactions: [],
        );
      }
    } catch (e, st) {
      log('Error updating user profile: $e', stackTrace: st);
    }
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>(
  (ref) => UserProfileNotifier(),
);
