import 'package:gloria_finance/core/layout/view_detail_widgets.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/models/availability_account_model.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/widgets/availability_account_delete_confirmation_dialog.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:gloria_finance/features/erp/settings/banks/models/bank_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewAvailabilityAccount extends StatelessWidget {
  final AvailabilityAccountModel account;
  final bool showActions;

  const ViewAvailabilityAccount({
    super.key,
    required this.account,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    bool mobile = isMobile(context);
    final l10n = context.l10n;
    final accountType = AccountTypeExtension.fromApiValue(account.accountType);
    final activeLabel =
        account.active
            ? l10n.settings_church_profile_status_active
            : l10n.settings_church_profile_status_inactive;

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
            if (showActions) ...[
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ButtonActionTable(
                    color: Colors.red,
                    text: l10n.common_delete,
                    onPressed: () => _delete(context),
                    icon: Icons.delete_outline,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _delete(BuildContext context) async {
    final confirmed = await showAvailabilityAccountDeleteConfirmationDialog(
      context,
      accountName: account.accountName,
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    final deleted = await context
        .read<AvailabilityAccountsListStore>()
        .deleteAvailabilityAccount(account.availabilityAccountId);

    if (!context.mounted) {
      return;
    }

    if (deleted) {
      Navigator.of(context).pop();
      Toast.showMessage(
        context.l10n.settings_availability_delete_toast_success,
        ToastType.info,
      );
    }
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
