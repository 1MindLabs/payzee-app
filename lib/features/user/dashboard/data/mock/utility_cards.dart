import 'package:upi_pay/features/user/dashboard/data/models/utility_card.dart';

final List<UtilityCard> utilityCards = [
  UtilityCard(
    name: 'govtSubsidyWallet',
    cardName: 'Govt. Subsidy Wallet',
    allocated: 0,
    remaining: 0,
    schemes: {
      'Kisan Dhan Yojna': 400.0,
      'Ujjwala Subsidy': 250.0,
      'PM Awas Yojna': 200.0,
    },
  ),
  UtilityCard(
    name: 'personalERupeeWallet',
    cardName: 'Personal e-Rupee Wallet',
    allocated: 0,
    remaining: 0,
    schemes: null,
  ),
];
