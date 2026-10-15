import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';

/// Etiqueta compacta y acotada.
///
/// No reutiliza `tagStatus` porque ese widget es de ancho infinito: solo es
/// válido dentro de una celda de tabla o de una columna, y rompe cualquier `Row`.
/// Este pill se mide por su contenido y admite texto oscuro legible.
class RecurringPaymentPill extends StatelessWidget {
  const RecurringPaymentPill({
    super.key,
    required this.label,
    required this.color,
    this.textColor,
  });

  final String label;
  final Color color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          fontSize: 12,
          color: textColor ?? _foregroundFor(color),
        ),
      ),
    );
  }

  /// Versión oscura de cada color de marca para que el texto tenga contraste
  /// sobre el fondo suave.
  Color _foregroundFor(Color color) {
    if (color == AppColors.green) return const Color(0xFF017C48);
    if (color == AppColors.blue) return const Color(0xFF1268AD);
    if (color == AppColors.purple) return AppColors.purple;
    if (color == AppColors.mustard) return const Color(0xFF8A5A00);
    return const Color(0xFFA52A2E);
  }
}
