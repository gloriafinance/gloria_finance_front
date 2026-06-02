import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:gloria_finance/l10n/app_localizations.dart';

import '../../store/pending_review_member_paginate_store.dart';
import 'widgets/pending_review_member_table.dart';

class PendingReviewMembersScreen extends StatelessWidget {
  const PendingReviewMembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PendingReviewMemberPaginateStore()..searchMemberList(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_header(context), const PendingReviewMemberTable()],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            AppLocalizations.of(context)!.member_pending_review_title,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 24,
              color: Colors.black,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: ButtonActionTable(
            color: AppColors.purple,
            text: AppLocalizations.of(context)!.member_pending_review_back,
            onPressed: () => GoRouter.of(context).go('/members'),
            icon: Icons.arrow_back_outlined,
          ),
        ),
      ],
    );
  }
}
