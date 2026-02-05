import 'package:gloria_finance/core/layout/view_detail_widgets.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/models/availability_account_model.dart';
import 'package:gloria_finance/features/erp/settings/banks/models/bank_model.dart';
import 'package:flutter/material.dart';

class ViewAvailabilityAccount extends StatelessWidget {
  final AvailabilityAccountModel account;

  const ViewAvailabilityAccount({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    bool mobile = isMobile(context);
    final l10n = context.l10n;
    final accountType = AccountTypeExtension.fromApiValue(account.accountType);
    final activeLabel =
        account.active ? l10n.member_list_status_yes : l10n.member_list_status_no;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitle(
              l10n.settings_availability_view_title(
                account.availabilityAccountId,
              ),
            ),
            const Divider(),
            SizedBox(height: 16),
            buildDetailRow(
              mobile,
              l10n.settings_availability_field_name,
              account.accountName,
            ),
            buildDetailRow(
              mobile,
              l10n.settings_availability_field_balance,
              CurrencyFormatter.formatCurrency(
                account.balance,
                symbol: account.symbol,
              ),
            ),
            buildDetailRow(
              mobile,
              l10n.settings_availability_field_type,
              accountType.friendlyName(l10n),
            ),
            buildDetailRow(
              mobile,
              l10n.settings_availability_field_active,
              activeLabel,
            ),
            const Divider(),
            if (account.source != null &&
                account.accountType == AccountType.BANK.apiValue)
              _sourceBank(context, account.getSource()),
          ],
        ),
      ),
    );
  }

  Widget _sourceBank(BuildContext context, BankModel bank) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTitle(l10n.settings_availability_bank_details_title),
        const Divider(),
        SizedBox(height: 16),
        buildDetailRow(false, l10n.settings_banks_field_name, bank.name),
        buildDetailRow(
          false,
          l10n.settings_banks_field_bank_code,
          bank.bankInstruction.codeBank,
        ),
        buildDetailRow(
          false,
          l10n.settings_banks_field_agency,
          bank.bankInstruction.agency,
        ),
        buildDetailRow(
          false,
          l10n.settings_banks_field_account,
          bank.bankInstruction.account,
        ),
      ],
    );
  }
}
