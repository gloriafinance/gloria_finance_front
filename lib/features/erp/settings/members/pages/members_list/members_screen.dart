import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:gloria_finance/l10n/app_localizations.dart';

import '../../store/member_paginate_store.dart';
import '../../store/member_registration_link_store.dart';
import 'widgets/member_registration_link_dialog.dart';
import 'widgets/member_table.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MemberPaginateStore()..searchMemberList(),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_header(context), MemberTable()],
      ),
    );
  }

  Widget _header(BuildContext context) {
    if (!isMobile(context)) {
      return Row(
        children: [
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.member_list_title,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: AppFonts.fontTitle,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          Align(alignment: Alignment.centerRight, child: _buttons(context)),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.member_list_title,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        _buttons(context),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buttons(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 8,
      children: [
        ButtonActionTable(
          color: AppColors.purple,
          text: AppLocalizations.of(context)!.member_list_action_register,
          onPressed: () => GoRouter.of(context).go('/member/add'),
          icon: Icons.add_reaction_outlined,
        ),
        ButtonActionTable(
          color: Colors.orange,
          text: AppLocalizations.of(context)!.member_pending_review_button,
          onPressed: () => GoRouter.of(context).go('/members/pending-review'),
          icon: Icons.pending_actions_outlined,
        ),
        ButtonActionTable(
          color: AppColors.purple,
          text: AppLocalizations.of(context)!.member_registration_link_button,
          onPressed: () => _showRegistrationLinkDialog(context),
          icon: Icons.person_add_alt_1_outlined,
        ),
      ],
    );
  }

  void _showRegistrationLinkDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ChangeNotifierProvider(
        create: (_) => MemberRegistrationLinkStore()..load(),
        child: const MemberRegistrationLinkDialog(),
      ),
    );
  }
}
