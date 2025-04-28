class UtilityCard {
  final String name;
  final String cardName;
  final double allocated, remaining;
  final Map<String, double>? schemes;
  UtilityCard({
    required this.name,
    required this.cardName,
    required this.allocated,
    required this.remaining,
    required this.schemes,
  });

  UtilityCard copyWith({
    String? name,
    String? cardName,
    double? allocated,
    double? remaining,
    Map<String, double>? schemes,
  }) {
    return UtilityCard(
      name: name ?? this.name,
      cardName: cardName ?? this.cardName,
      allocated: allocated ?? this.allocated,
      remaining: remaining ?? this.remaining,
      schemes: schemes ?? this.schemes,
    );
  }
}
