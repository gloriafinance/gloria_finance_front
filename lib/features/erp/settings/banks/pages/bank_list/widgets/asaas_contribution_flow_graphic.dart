import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';

class AsaasContributionFlowGraphic extends StatelessWidget {
  final bool isCompact;

  const AsaasContributionFlowGraphic({super.key, required this.isCompact});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCompact ? 240 : 248,
      height: isCompact ? 110 : 108,
      padding: EdgeInsets.symmetric(horizontal: isCompact ? 22 : 24),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(66),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.person_outline,
                size: 52,
                color: AppColors.purple,
              ),
              const Positioned(
                right: -4,
                bottom: 0,
                child: CircleAvatar(
                  radius: 13,
                  backgroundColor: AppColors.green,
                  child: Icon(Icons.check, size: 17, color: Colors.white),
                ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.qr_code_2_outlined,
                size: 34,
                color: AppColors.green,
              ),
              Text(
                'PIX',
                style: TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                  fontSize: 24,
                  color: AppColors.grey.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const Icon(Icons.church_outlined, size: 54, color: AppColors.purple),
        ],
      ),
    );
  }
}
