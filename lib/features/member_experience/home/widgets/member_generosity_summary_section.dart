import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/currency_formatter.dart';
import 'package:church_finance_bk/core/utils/general.dart';
import 'package:church_finance_bk/features/member_experience/home/store/member_generosity_summary_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MemberGenerositySummarySection extends StatelessWidget {
  const MemberGenerositySummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isMobileLayout = isMobile(context);

    return Consumer<MemberGenerositySummaryStore>(
      builder: (context, store, child) {
        final summary = store.summary;
        final symbol = store.symbolFormatMoney;

        final cards = [
          _SummaryCard(
            title: l10n.member_home_generosity_year_label,
            value: CurrencyFormatter.formatCurrency(
              summary.contributedYear,
              symbol: symbol,
            ),
          ),
          _SummaryCard(
            title: l10n.member_home_generosity_month_label,
            value: CurrencyFormatter.formatCurrency(
              summary.contributedMonth,
              symbol: symbol,
            ),
          ),
          _SummaryCard(
            title: l10n.member_home_generosity_commitments_label,
            value: summary.activeCommitments.toString(),
            footnote: l10n.member_home_generosity_commitments_hint,
            onTap: () => context.push('/member/commitments'),
          ),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.member_home_generosity_title,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontTitle,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  if (store.isLoading)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Opacity(
              opacity: store.isLoading ? 0.6 : 1,
              child:
                  isMobileLayout
                      ? SizedBox(
                        height: 120,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          scrollDirection: Axis.horizontal,
                          itemCount: cards.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder:
                              (context, index) =>
                                  SizedBox(width: 120, child: cards[index]),
                        ),
                      )
                      : Row(
                        children: [
                          Expanded(child: cards[0]),
                          const SizedBox(width: 12),
                          Expanded(child: cards[1]),
                          const SizedBox(width: 12),
                          Expanded(child: cards[2]),
                        ],
                      ),
            ),
          ],
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String? footnote;
  final VoidCallback? onTap;

  const _SummaryCard({
    required this.title,
    required this.value,
    this.footnote,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      height: 120,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withAlpha(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.purple,
            ),
          ),
          if (footnote != null) ...[
            const SizedBox(height: 4),
            Text(
              footnote!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.fontText,
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ],
      ),
    );

    if (onTap == null) return content;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: content,
    );
  }
}
