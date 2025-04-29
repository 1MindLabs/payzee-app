import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:upi_pay/core/provider/locale_provider.dart';
import 'package:upi_pay/features/user/dashboard/data/mock/utility_cards.dart';
import 'package:upi_pay/features/user/dashboard/data/models/user_profile.dart';
import 'package:upi_pay/features/user/dashboard/data/services/profile_service.dart';
import 'package:upi_pay/features/user/dashboard/presentation/providers/user_profile_provider.dart';
import 'package:upi_pay/features/user/dashboard/presentation/screens/map_screen.dart';
import 'package:upi_pay/features/user/dashboard/presentation/screens/wallet_summary_screen.dart';
import 'package:upi_pay/features/user/dashboard/presentation/widgets/choose_payment_option_bottom_sheet.dart';
import 'package:upi_pay/features/user/dashboard/presentation/widgets/confetti_card.dart';
import 'package:upi_pay/features/user/dashboard/presentation/widgets/language_menu.dart';
import 'package:upi_pay/features/user/dashboard/presentation/widgets/past_transaction_tile.dart';
import 'package:upi_pay/features/user/dashboard/presentation/widgets/wallet_functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final ProfileService profileService = ProfileService();
  final PageController _pageController = PageController(viewportFraction: 0.88);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    loadProfile();
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void updateUtilityCards(UserProfile userProfile) {
    log('Updating utility cards with user profile data');
    log('User Profile: $userProfile');
    final govtCardIndex = 0;
    if (govtCardIndex == 0) {
      utilityCards[govtCardIndex] = utilityCards[govtCardIndex].copyWith(
        allocated: double.tryParse(userProfile.govtWallet.toString()) ?? 0,
        remaining: double.tryParse(userProfile.remainingAmt.toString()) ?? 0,
      );
    }

    log('govt card: ${utilityCards[govtCardIndex]}');

    final personalCardIndex = 1;
    if (personalCardIndex == 1) {
      utilityCards[personalCardIndex] = utilityCards[personalCardIndex]
          .copyWith(
            allocated:
                double.tryParse(userProfile.personalWallet.toString()) ?? 0,
            remaining:
                double.tryParse(userProfile.personalWallet.toString()) ?? 0,
          );
    }

    setState(() {});
  }

  Future<void> loadProfile() async {
    await ref
        .read(userProfileProvider.notifier)
        .updateUserProfile(profileService);

    final userProfile = ref.watch(userProfileProvider);
    log('User profile fetched in screen: $userProfile');
    if (userProfile != null) {
      updateUtilityCards(userProfile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final theme = Theme.of(context);

    final totalAllocated = utilityCards.fold<double>(
      0,
      (sum, c) => sum + c.allocated,
    );
    final totalRemaining = utilityCards.fold<double>(
      0,
      (sum, c) => sum + c.remaining,
    );
    final fmt = NumberFormat.simpleCurrency(locale: 'en_IN', name: '₹');

    final locale = ref.watch(localeProvider);

    final size = MediaQuery.of(context).size;
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = Color(0xFF6C63FF); // Purple accent color
    final backgroundColor = isDarkMode ? Color(0xFF121212) : Color(0xFFF7F9FC);
    final cardColor = isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
    final shadowColor = isDarkMode ? Colors.black54 : Colors.black12;

    // Page indicator dots
    final List<Widget> dots = List.generate(
      utilityCards.length,
      (index) => Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        height: 8,
        width: _currentPage == index ? 24 : 8,
        decoration: BoxDecoration(
          color: _currentPage == index ? primaryColor : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            // App Bar
            SliverAppBar(
              pinned: true,
              backgroundColor: backgroundColor,
              elevation: 0,
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.appTitle,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          if (userProfile != null)
                            Text(
                              "Hello, ${userProfile.userId}",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: primaryColor.withOpacity(0.2),
                        child: Icon(
                          Icons.person,
                          color: primaryColor,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Main Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Wallet Cards
                    SizedBox(
                      height: 220,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: utilityCards.length,
                        itemBuilder:
                            (_, i) => GestureDetector(
                              onTap:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              WalletSummaryScreen(idx: i),
                                    ),
                                  ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 8,
                                ),
                                child: ConfettiCard(card: utilityCards[i]),
                              ),
                            ),
                      ),
                    ),

                    // Page Indicator
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: dots,
                      ),
                    ),

                    // Balance Summary
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: shadowColor,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.totalAllocated,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  fmt.format(totalAllocated),
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isDarkMode
                                            ? Colors.white
                                            : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.grey.shade200,
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.totalRemaining,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  fmt.format(totalRemaining),
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 24),

                    // Quick Actions
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        AppLocalizations.of(context)!.load,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Actions Grid
                    Container(
                      height: locale == Locale('kn') ? 180 : 150,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        childAspectRatio: 0.9,
                        children: [
                          ActionItem(
                            icon: Icons.pin_drop_rounded,
                            title: AppLocalizations.of(context)!.map,
                            color: Color(0xFFFF7F50),
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MapScreen(),
                                  ),
                                ),
                          ),
                          ActionItem(
                            icon: Icons.token,
                            title: AppLocalizations.of(context)!.collect,
                            color: Color(0xFF4CAF50),
                            onTap: () {},
                          ),
                          ActionItem(
                            icon: Icons.account_balance_wallet,
                            title: AppLocalizations.of(context)!.load,
                            color: Color(0xFF2196F3),
                            onTap: () {},
                          ),
                          ActionItem(
                            icon: Icons.translate,
                            title: AppLocalizations.of(context)!.language,
                            color: Color(0xFF9C27B0),
                            onTap:
                                () => showModalBottomSheet(
                                  context: context,
                                  builder:
                                      (context) =>
                                          const LanguageSelectionSheet(),
                                  isScrollControlled: true,
                                ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox.shrink(),

                    // Past Transactions
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.pastTransactions,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          // TextButton(
                          //   onPressed: () {
                          //     // View all transactions
                          //   },
                          //   child: Text(
                          //     AppLocalizations.of(context)!.collect,
                          //     style: GoogleFonts.poppins(
                          //       fontSize: 14,
                          //       color: primaryColor,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),

                    SizedBox(height: 8),

                    const SizedBox(height: 8),

                    ListView.builder(
                      shrinkWrap: true, // Add this
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: userProfile.pastTransactions.length,
                      itemBuilder:
                          (_, i) => PastTransactionTile(
                            txn: userProfile.pastTransactions[i],
                          ),
                    ),

                    // Space for FAB
                    SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        onPressed: () {
          showPaymentOptions(context);
        },
        icon: Icon(Icons.payment),
        label: Text(
          AppLocalizations.of(context)!.payment,
          style: GoogleFonts.poppins(),
        ),
        elevation: 4,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ActionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const ActionItem({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final dynamic txn;
  final Color cardColor;
  final Color shadowColor;

  const TransactionCard({
    required this.txn,
    required this.cardColor,
    required this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.simpleCurrency(
      locale: 'en_IN',
      name: '₹',
    );
    final iconMapping = {
      'food': Icons.restaurant,
      'transport': Icons.directions_bus,
      'health': Icons.local_hospital,
      'education': Icons.school,
      'other': Icons.category,
    };

    final colorMapping = {
      'food': Color(0xFFFF9800),
      'transport': Color(0xFF03A9F4),
      'health': Color(0xFFE91E63),
      'education': Color(0xFF4CAF50),
      'other': Color(0xFF9E9E9E),
    };

    final category = txn.category?.toLowerCase() ?? 'other';
    final icon = iconMapping[category] ?? Icons.category;
    final color = colorMapping[category] ?? Color(0xFF9E9E9E);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: shadowColor, blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          title: Text(
            txn.name ?? 'Unknown',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            txn.date ?? 'No date',
            style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12),
          ),
          trailing: Text(
            numberFormat.format(txn.amount ?? 0),
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color:
                  (txn.isCredit ?? false)
                      ? Color(0xFF4CAF50)
                      : Color(0xFFFF5252),
            ),
          ),
        ),
      ),
    );
  }
}
