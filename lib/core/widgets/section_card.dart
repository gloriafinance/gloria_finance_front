import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/index.dart';

/// Superficie de sección para formularios del ERP.
///
/// Movido desde `accounts_payable/.../widgets/section_card.dart` para que sea
/// una primitive compartida y no se duplique en cada feature nuevo.
class SectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;

  /// Contenido opcional a la derecha del título (por ejemplo una etiqueta
  /// "Opcional").
  final Widget? titleSuffix;

  /// Número de sección mostrado junto al título. Útil en formularios largos.
  final int? index;

  /// Color del borde cuando la sección necesita jerarquía propia.
  final Color? borderColor;

  final List<Widget> children;

  const SectionCard({
    super.key,
    required this.title,
    this.subtitle,
    this.titleSuffix,
    this.index,
    this.borderColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor ?? AppColors.greyMiddle),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index != null) ...[
                _SectionIndex(index: index!),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontFamily: AppFonts.fontTitle,
                              fontSize: 18,
                              color: AppColors.purple,
                            ),
                          ),
                        ),
                        if (titleSuffix != null) ...[
                          const SizedBox(width: 10),
                          titleSuffix!,
                        ],
                      ],
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontFamily: AppFonts.fontSubTitle,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
}

class _SectionIndex extends StatelessWidget {
  const _SectionIndex({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.purple.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        '$index',
        style: const TextStyle(
          fontFamily: AppFonts.fontTitle,
          fontSize: 13,
          color: AppColors.purple,
        ),
      ),
    );
  }
}
