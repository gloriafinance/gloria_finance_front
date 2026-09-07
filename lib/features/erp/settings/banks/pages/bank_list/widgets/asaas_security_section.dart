import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';

class AsaasSecuritySection extends StatelessWidget {
  const AsaasSecuritySection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 600;
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 16 : 24,
            vertical: isCompact ? 16 : 22,
          ),
          decoration: BoxDecoration(
            color: AppColors.purple.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.purple.withValues(alpha: 0.16)),
          ),
          child: Row(
            children: [
              Container(
                width: isCompact ? 56 : 72,
                height: isCompact ? 56 : 72,
                decoration: BoxDecoration(
                  color: AppColors.purple,
                  borderRadius: BorderRadius.circular(isCompact ? 12 : 14),
                ),
                child: Icon(
                  Icons.shield_outlined,
                  color: Colors.white,
                  size: isCompact ? 30 : 38,
                ),
              ),
              SizedBox(width: isCompact ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.settings_banks_asaas_security_title,
                      style: TextStyle(
                        fontFamily: AppFonts.fontTitle,
                        fontSize: isCompact ? 16 : 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      l10n.settings_banks_asaas_security_description,
                      style: TextStyle(
                        fontFamily: AppFonts.fontSubTitle,
                        fontSize: isCompact ? 14 : 16,
                        color: AppColors.grey,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isCompact) ...[
                const SizedBox(width: 16),
                Icon(
                  Icons.lock_outline,
                  color: AppColors.purple.withValues(alpha: 0.22),
                  size: 72,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
