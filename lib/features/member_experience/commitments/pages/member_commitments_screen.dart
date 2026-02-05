import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/member_experience/commitments/store/member_commitment_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../widgets/member_header.dart';
import 'widgets/member_commitment_card.dart';
import 'widgets/member_commitment_empty_state.dart';

class MemberCommitmentsScreen extends StatelessWidget {
  const MemberCommitmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MemberCommitmentStore()..loadCommitments(),
      child: Consumer<MemberCommitmentStore>(
        builder: (context, store, _) {
          final l10n = context.l10n;

          return RefreshIndicator(
            onRefresh: () => store.loadCommitments(refresh: true),
            child: ListView(
              children: [
                MemberHeaderWidget(
                  title: l10n.member_commitments_title,
                  subtitle: l10n.member_commitments_empty_subtitle,
                ),
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
