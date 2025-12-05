import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/features/member_experience/commitments/store/member_commitment_store.dart';
import 'package:church_finance_bk/features/member_experience/commitments/widgets/member_commitment_card.dart';
import 'package:church_finance_bk/features/member_experience/commitments/widgets/member_commitment_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MemberCommitmentsScreen extends StatelessWidget {
  const MemberCommitmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MemberCommitmentStore()..loadCommitments(),
      child: Consumer<MemberCommitmentStore>(
        builder: (context, store, _) {
          return RefreshIndicator(
            onRefresh: () => store.loadCommitments(refresh: true),
            child: ListView(
              children: [
                const _HeaderSection(),
                const SizedBox(height: 20),
                if (store.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (store.commitments.isEmpty)
                  const MemberCommitmentEmptyState()
                else
                  ...store.commitments.map(
                    (commitment) => MemberCommitmentCard(
                      commitment: commitment,
                      onTap: () async {
                        final result = await context.push<bool>(
                          '/member/commitments/detail',
                          extra: commitment,
                        );
                        if (result == true) {
                          store.loadCommitments(refresh: true);
                        }
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.purple,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.member_commitments_title,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.member_commitments_empty_subtitle,
            style: const TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
