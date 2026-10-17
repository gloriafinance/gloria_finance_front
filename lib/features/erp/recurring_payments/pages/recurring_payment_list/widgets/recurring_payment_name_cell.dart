import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';

/// Celda de nombre con una segunda línea de contexto.
///
/// Agrupa en una sola columna el nombre y sus metadatos para que la tabla quepa
/// sin scroll horizontal, sin perder información.
class RecurringPaymentNameCell extends StatelessWidget {
  const RecurringPaymentNameCell({
    super.key,
    required this.name,
    required this.subtitle,
    this.subtitleColor,
    this.maxWidth = 220,
  });

  final String name;
  final String subtitle;
  final Color? subtitleColor;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 13.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 11.5,
              color: subtitleColor ?? AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
