import 'package:church_finance_bk/core/layout/modal_page_layout.dart';
import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/features/erp/settings/availability_accounts/models/availability_account_model.dart';
import 'package:church_finance_bk/features/erp/settings/availability_accounts/pages/list_availability_accounts/widgets/view_availabilityAccount_account.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/availability_accounts_list_store.dart';

class AvailabilityAccountTable extends StatefulWidget {
  const AvailabilityAccountTable({super.key});

  @override
  State<StatefulWidget> createState() => _AvailabilityAccountTable();
}

class _AvailabilityAccountTable extends State<AvailabilityAccountTable> {
  @override
  Widget build(BuildContext context) {
    final store = context.watch<AvailabilityAccountsListStore>();

    final state = store.state;

    if (state.makeRequest) {
      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 40.0),
        child: CircularProgressIndicator(),
      );
    }

    if (state.availabilityAccounts.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 40.0),
        child: Center(child: Text(context.l10n.common_no_results_found)),
      );
    }

    return CustomTable(
      headers: [
        context.l10n.settings_availability_table_header_name,
        context.l10n.settings_availability_table_header_type,
        context.l10n.settings_availability_table_header_balance,
        context.l10n.settings_availability_table_header_status,
      ],
      data: FactoryDataTable<dynamic>(
        data: state.availabilityAccounts,
        dataBuilder: (account) => accountDTO(context, account),
      ),
      actionBuilders: [
        (account) => ButtonActionTable(
          color: AppColors.blue,
          text: context.l10n.common_view,
          onPressed: () {
            _openModal(context, account);
          },
          icon: Icons.remove_red_eye_sharp,
        ),
      ],
    );
  }

  void _openModal(BuildContext context, AvailabilityAccountModel account) {
    ModalPage(
      title:
          isMobile(context)
              ? ""
              : context.l10n.settings_availability_view_title(
                account.availabilityAccountId,
              ),
      body: ViewAvailabilityAccount(account: account),
    ).show(context);
  }

  List<dynamic> accountDTO(BuildContext context, dynamic account) {
    final l10n = context.l10n;
    final accountType = AccountTypeExtension.fromApiValue(account.accountType);
    final statusLabel =
        account.active
            ? l10n.schedule_status_active
            : l10n.schedule_status_inactive;

    return [
      account.accountName,
      accountType.friendlyName(l10n),
      CurrencyFormatter.formatCurrency(account.balance, symbol: account.symbol),
      statusLabel,
    ];
  }
}
