import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';

class SupportAssistantHeader extends StatelessWidget {
  const SupportAssistantHeader({super.key, required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final canGoBack = context.canPop();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (canGoBack) ...[
              GestureDetector(
                onTap: () => context.pop(),
                child: const Padding(
                  padding: EdgeInsets.only(top: 4, right: 8),
                  child: Icon(Icons.arrow_back_ios, color: AppColors.purple),
                ),
              ),
            ],
            Expanded(
              child: Text(
                context.l10n.support_assistant_title,
                style: TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: isCompact ? 22 : 26,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          isCompact
              ? context.l10n.support_assistant_header_compact
              : context.l10n.support_assistant_header_wide,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
