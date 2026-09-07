import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';

class AsaasHowItWorksDialogHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onClose;
  final bool isCompact;

  const AsaasHowItWorksDialogHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onClose,
    required this.isCompact,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _icon(56, 30),
              const SizedBox(width: 12),
              Expanded(child: _title(24, const EdgeInsets.only(top: 3))),
              IconButton(
                onPressed: onClose,
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.all(6),
                icon: const Icon(Icons.close, color: AppColors.grey, size: 26),
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 68, top: 4),
            child: _subtitle(14),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _icon(96, 46),
        const SizedBox(width: 22),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title(36, EdgeInsets.zero),
                const SizedBox(height: 8),
                _subtitle(17),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: onClose,
          icon: const Icon(Icons.close, color: AppColors.grey, size: 30),
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
        ),
      ],
    );
  }

  Widget _icon(double size, double iconSize) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.purple.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.menu_book_outlined,
        color: AppColors.purple,
        size: iconSize,
      ),
    );
  }

  Widget _title(double size, EdgeInsets padding) {
    return Padding(
      padding: padding,
      child: Text(
        title,
        style: TextStyle(
          fontFamily: AppFonts.fontTitle,
          fontSize: size,
          color: Colors.black,
          height: 1.15,
        ),
      ),
    );
  }

  Widget _subtitle(double size) {
    return Text(
      subtitle,
      style: TextStyle(
        fontFamily: AppFonts.fontSubTitle,
        fontSize: size,
        color: AppColors.grey,
        height: 1.4,
      ),
    );
  }
}
