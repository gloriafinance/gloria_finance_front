import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/loading.dart';
import 'package:gloria_finance/features/member_experience/contributions/pages/history/widgets/contribution_history_item.dart';
import 'package:gloria_finance/features/member_experience/contributions/store/member_contribution_history_store.dart';
import 'package:flutter/material.dart';

class ContributionList extends StatelessWidget {
  final MemberContributionHistoryStore store;

  const ContributionList({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final grouped = store.groupedContributions;

    return ListView.builder(
      itemCount: grouped.length + (store.nextPag != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == grouped.length) {
          // Load more button or indicator
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child:
                  store.isLoading
                      ? const Loading()
                      : TextButton(
                        onPressed: store.loadMore,
                        child: Text(context.l10n.common_load_more),
                      ),
            ),
          );
        }

        final monthKey = grouped.keys.elementAt(index);
        final contributions = grouped[monthKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 8),
              child: Text(
                monthKey,
                style: TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children:
                    contributions.map((contribution) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ContributionHistoryItem(
                          contribution: contribution,
                        ),
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}
