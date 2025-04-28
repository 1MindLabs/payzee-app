import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:upi_pay/features/user/dashboard/data/models/utility_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:upi_pay/l10n/l10n_extension.dart';

class ConfettiCard extends StatelessWidget {
  final UtilityCard card;
  const ConfettiCard({required this.card, super.key});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.simpleCurrency(locale: 'en_IN', name: '₹');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        children: [
          // Base black card
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
          ),

          // Confetti rectangles
          ...[
            Positioned(
              left: 16,
              top: 16,
              child: _confettiRect(Colors.pinkAccent),
            ),
            Positioned(
              right: 24,
              top: 40,
              child: _confettiRect(Colors.blueAccent),
            ),
            Positioned(
              left: 80,
              bottom: 55,
              child: _confettiRect(Colors.orangeAccent),
            ),
            Positioned(
              right: 60,
              bottom: 16,
              child: _confettiRect(Colors.greenAccent),
            ),
          ],

          // Speaker button

          // Content
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.translateUtilityName(card.name, context),
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Text(
                    AppLocalizations.of(context)!.remainingBalance,
                    style: GoogleFonts.roboto(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    fmt.format(card.remaining),
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _confettiRect(Color color) => Container(
    width: 20,
    height: 6,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(2),
    ),
  );
}
