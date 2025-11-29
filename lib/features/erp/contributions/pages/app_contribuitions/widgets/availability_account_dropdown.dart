import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/features/erp//settings/availability_accounts/models/availability_account_model.dart';
import 'package:church_finance_bk/features/erp//settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:flutter/material.dart';

Widget availabilityAccountDropdown({
  required AvailabilityAccountsListStore availabilityAccountsListStore,
  required void Function(AvailabilityAccountModel account) onChanged,
  String? Function(String?)? onValidator,
  String? selectedAvailabilityAccountId,
}) {
  final accounts =
      availabilityAccountsListStore.state.availabilityAccounts
          .where((a) => a.accountType != AccountType.INVESTMENT.apiValue)
          .toList();

  String? initialValue;
  for (final account in accounts) {
    if (account.availabilityAccountId == selectedAvailabilityAccountId) {
      initialValue = account.accountName;
      break;
    }
  }

  return Dropdown(
    label: "Conta de disponiblidade",
    items: accounts.map((a) => a.accountName).toList(),
    onValidator: onValidator,
    initialValue: initialValue,
    onChanged: (value) {
      final selectedAccount = accounts.firstWhere(
        (account) => account.accountName == value,
      );

      onChanged(selectedAccount);
    },
  );
}
