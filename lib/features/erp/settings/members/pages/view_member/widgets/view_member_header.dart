import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';

class ViewMemberHeader extends StatelessWidget {
  final bool mobile;
  final Widget? statusBadge;

  const ViewMemberHeader({super.key, required this.mobile, this.statusBadge});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            InkWell(
              onTap: () => context.go('/members'),
              borderRadius: BorderRadius.circular(999),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.greyMiddle),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: AppColors.purple,
                ),
              ),
            ),
            Text(
              l10n.member_view_title,
              style: TextStyle(
                fontFamily: AppFonts.fontTitle,
                fontSize: mobile ? 26 : 30,
                color: AppColors.black,
              ),
            ),
            if (statusBadge != null) statusBadge!,
          ],
        ),
        const SizedBox(height: 12),
        Text(
          l10n.member_view_description,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 15,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }
}
