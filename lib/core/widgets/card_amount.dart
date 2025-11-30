import 'package:flutter/material.dart';

import '../utils/currency_formatter.dart';
import '../theme/app_color.dart';
import '../theme/app_fonts.dart';

class CardAmount extends StatelessWidget {
  final String title;
  final double amount;
  final String symbol;
  final Color bgColor;
  final IconData icon;
  final String? subtitle;

  const CardAmount({
    super.key,
    required this.title,
    required this.amount,
    required this.symbol,
    required this.bgColor,
    required this.icon,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 180,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            color: bgColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Icono con color
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: bgColor, size: 24),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: AppFonts.fontTitle,
                              color: AppColors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            (subtitle ?? '').isNotEmpty
                                ? (subtitle ?? '').toUpperCase()
                                : '',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: AppFonts.fontSubTitle,
                              color: AppColors.black,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Monto con color acorde al tipo de cuenta
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    CurrencyFormatter.formatCurrency(
                      amount ?? 0.0,
                      symbol: symbol,
                    ),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.fontTitle,
                      color: bgColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
