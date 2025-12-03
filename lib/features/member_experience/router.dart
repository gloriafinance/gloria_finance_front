import 'package:church_finance_bk/core/theme/transition_custom.dart';
import 'package:flutter/material.dart';
import 'package:church_finance_bk/features/member_experience/contributions/models/member_contribution_models.dart';
import 'package:church_finance_bk/features/member_experience/contributions/pages/contribute/member_contribute_boleto_screen.dart';
import 'package:church_finance_bk/features/member_experience/contributions/pages/contribute/member_contribute_pix_screen.dart';
import 'package:church_finance_bk/features/member_experience/contributions/pages/contribute/member_contribute_result_screen.dart';
import 'package:church_finance_bk/features/member_experience/contributions/pages/contribute/member_contribute_screen.dart';
import 'package:church_finance_bk/features/member_experience/contributions/pages/history/member_contribution_history_screen.dart';
import 'package:go_router/go_router.dart';

import 'home/home_screen.dart';

memberExperienceRouter() {
  return <RouteBase>[
    GoRoute(
      path: '/financial-record',
      pageBuilder: (context, state) {
        return transitionCustom(HomeScreen());
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
