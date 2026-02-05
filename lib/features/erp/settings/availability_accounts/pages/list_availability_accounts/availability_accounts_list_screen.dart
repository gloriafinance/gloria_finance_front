import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/availability_account_table.dart';

class AvailabilityAccountsListScreen extends StatefulWidget {
  const AvailabilityAccountsListScreen({super.key});

  @override
  State<AvailabilityAccountsListScreen> createState() =>
      _AvailabilityAccountsListScreenState();
}

class _AvailabilityAccountsListScreenState
    extends State<AvailabilityAccountsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_header(context), AvailabilityAccountTable()],
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            context.l10n.settings_availability_list_title,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 24,
              color: Colors.black,
            ),
          ),
        ),
        Align(alignment: Alignment.centerRight, child: _buttons(context)),
      ],
    );
  }

  Widget _buttons(BuildContext context) {
    return Row(
      children: [
        ButtonActionTable(
          color: AppColors.purple,
          text: context.l10n.settings_availability_new_account,
          onPressed:
              () => GoRouter.of(context).go('/availability-accounts/add'),
          icon: Icons.add_box_outlined,
        ),
      ],
    );
  }
}
