import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';

/// Linha de dado herdado: rótulo à esquerda, valor à direita.
///
/// É o formato de tudo que a configuração já sabe e a tela só confirma.
class RecurringPaymentExecutionField extends StatelessWidget {
  const RecurringPaymentExecutionField({
    super.key,
    required this.label,
    required this.value,
    this.note,
    this.emphasized = false,
    this.dense = false,
  });

  final String label;
  final String value;

  /// De onde vem o dado ("Configurado no pagamento recorrente").
  final String? note;
  final bool emphasized;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: dense ? 3 : 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 116,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: AppFonts.fontText,
                fontSize: 12.5,
                color: AppColors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontFamily:
                        emphasized ? AppFonts.fontTitle : AppFonts.fontSubTitle,
                    fontSize: emphasized ? 16 : 13.5,
                    color: Colors.black,
                  ),
                ),
                if (note != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      note!,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontText,
                        fontSize: 11.5,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Título de seção dentro das folhas de execução.
class RecurringPaymentExecutionSectionTitle extends StatelessWidget {
  const RecurringPaymentExecutionSectionTitle({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontFamily: AppFonts.fontTitle,
          fontSize: 13,
          letterSpacing: 0.3,
          color: AppColors.purple,
        ),
      ),
    );
  }
}

/// Aviso neutro para explicar uma regra da execução.
class RecurringPaymentExecutionNotice extends StatelessWidget {
  const RecurringPaymentExecutionNotice({
    super.key,
    required this.text,
    this.icon = Icons.info_outline,
    this.color = AppColors.grey,
  });

  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: AppFonts.fontText,
                fontSize: 12,
                height: 1.6,
                color: Color(0xFF5F5F5F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
