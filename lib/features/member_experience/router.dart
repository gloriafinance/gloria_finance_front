import 'package:church_finance_bk/core/theme/transition_custom.dart';
import 'package:church_finance_bk/features/member_experience/commitments/models/member_commitment_model.dart';
import 'package:church_finance_bk/features/member_experience/commitments/pages/member_commitment_detail_screen.dart';
import 'package:church_finance_bk/features/member_experience/commitments/pages/member_commitments_screen.dart';
import 'package:church_finance_bk/features/member_experience/contributions/models/member_contribution_models.dart';
import 'package:church_finance_bk/features/member_experience/contributions/pages/contribute/member_contribute_boleto_screen.dart';
import 'package:church_finance_bk/features/member_experience/contributions/pages/contribute/member_contribute_pix_screen.dart';
import 'package:church_finance_bk/features/member_experience/contributions/pages/contribute/member_contribute_result_screen.dart';
import 'package:church_finance_bk/features/member_experience/contributions/pages/contribute/member_contribute_screen.dart';
import 'package:church_finance_bk/features/member_experience/contributions/pages/history/member_contribution_history_screen.dart';
import 'package:church_finance_bk/features/member_experience/home/home_screen.dart';
import 'package:church_finance_bk/features/member_experience/profile/pages/member_profile_screen.dart';
import 'package:church_finance_bk/features/member_experience/profile/pages/change_password/member_change_password_screen.dart';
import 'package:church_finance_bk/features/member_experience/schedule/pages/member_schedule_list_screen.dart';
import 'package:church_finance_bk/features/member_experience/settings/pages/member_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

memberExperienceRouter() {
  return <RouteBase>[
    GoRoute(
      path: '/financial-record',
      pageBuilder: (context, state) {
        return transitionCustom(HomeScreen());
      },
    ),
    GoRoute(
      path: '/member/settings',
      pageBuilder: (context, state) {
        return transitionCustom(const MemberSettingsScreen());
      },
    ),
    GoRoute(
      path: '/member/profile',
      pageBuilder: (context, state) {
        return transitionCustom(const MemberProfileScreen());
      },
      routes: [
        GoRoute(
          path: 'change-password',
          pageBuilder: (context, state) {
            return transitionCustom(const MemberChangePasswordScreen());
          },
        ),
      ],
    ),
    GoRoute(
      path: '/member/commitments',
      pageBuilder: (context, state) {
        return transitionCustom(const MemberCommitmentsScreen());
      },
      routes: [
        GoRoute(
          path: 'detail',
          pageBuilder: (context, state) {
            final commitment = state.extra as MemberCommitmentModel;
            return transitionCustom(
              MemberCommitmentDetailScreen(commitment: commitment),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/member/schedule',
      pageBuilder: (context, state) {
        return transitionCustom(const MemberScheduleListScreen());
      },
    ),
    // Contribution History (Main Entry)
    GoRoute(
      path: '/member/contribute',
      pageBuilder: (context, state) {
        return transitionCustom(
          MemberContributionHistoryScreen(key: UniqueKey()),
        );
      },
      routes: [
        // New Contribution Form
        GoRoute(
          path: 'new',
          pageBuilder: (context, state) {
            return transitionCustom(const MemberContributeScreen());
          },
        ),
      ],
    ),
    // PIX payment screen
    GoRoute(
      path: '/member/contribute/pix/:id',
      pageBuilder: (context, state) {
        final pixPayload = state.extra as PixChargeResponse;
        return transitionCustom(
          MemberContributePixScreen(pixPayload: pixPayload),
        );
      },
    ),
    // Boleto payment screen
    GoRoute(
      path: '/member/contribute/boleto/:id',
      pageBuilder: (context, state) {
        final boletoPayload = state.extra as BoletoChargeResponse;
        return transitionCustom(
          MemberContributeBoletoScreen(boletoPayload: boletoPayload),
        );
      },
    ),
    // Result screen
    GoRoute(
      path: '/member/contribute/result',
      pageBuilder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return transitionCustom(
          MemberContributeResultScreen(
            success: data['success'] ?? false,
            type: data['type'] as MemberContributionType?,
            amount: data['amount'] as double?,
            paidAt: data['paidAt'] as DateTime?,
            errorMessage: data['errorMessage'] as String?,
          ),
        );
      },
    ),
  ];
}
