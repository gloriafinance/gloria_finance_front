import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/models/availability_account_model.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:provider/provider.dart';

import '../../../store/recurring_payment_execution_store.dart';

class RecurringPaymentAvailabilityAccountStep extends StatefulWidget {
  const RecurringPaymentAvailabilityAccountStep({
    super.key,
    required this.onContinue,
  });

  final VoidCallback onContinue;

  @override
  State<RecurringPaymentAvailabilityAccountStep> createState() =>
      _RecurringPaymentAvailabilityAccountStepState();
}

class _RecurringPaymentAvailabilityAccountStepState
    extends State<RecurringPaymentAvailabilityAccountStep> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final accountsStore = context.read<AvailabilityAccountsListStore>();
      if (accountsStore.state.availabilityAccounts.isEmpty) {
        accountsStore.searchAvailabilityAccounts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final executionStore = context.watch<RecurringPaymentExecutionStore>();
    final accountsStore = context.watch<AvailabilityAccountsListStore>();
    final accounts =
        accountsStore.state.availabilityAccounts
            .where(
              (account) =>
                  account.active &&
                  account.accountType != AccountType.INVESTMENT.apiValue,
            )
            .toList();
    final selectedAccountId = executionStore.state.availabilityAccountId;
    final hasSelection = accounts.any(
      (account) => account.availabilityAccountId == selectedAccountId,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.recurringPaymentsExecution_account_selection_description,
          style: const TextStyle(fontSize: 13, color: Color(0xFF5F5F5F)),
        ),
        const SizedBox(height: 16),
        if (accounts.isEmpty && accountsStore.state.makeRequest)
          const Center(child: CircularProgressIndicator())
        else if (accounts.isEmpty)
          Text(
            l10n.recurringPaymentsExecution_account_selection_empty,
            style: const TextStyle(fontSize: 13, color: AppColors.grey),
          )
        else
          ...accounts.map((account) {
            final selected = account.availabilityAccountId == selectedAccountId;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap:
                      () => context
                          .read<RecurringPaymentExecutionStore>()
                          .setAvailabilityAccountId(
                            account.availabilityAccountId,
                          ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            selected
                                ? AppColors.purple
                                : const Color(0xFFE8E6E9),
                        width: selected ? 1.4 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.account_balance_outlined,
                          color: selected ? AppColors.purple : AppColors.grey,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            account.accountName,
                            style: const TextStyle(
                              fontFamily: AppFonts.fontSubTitle,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Icon(
                          selected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: selected ? AppColors.purple : AppColors.grey,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        const SizedBox(height: 20),
        CustomButton(
          text: l10n.recurringPaymentsExecution_account_selection_continue,
          backgroundColor: AppColors.green,
          disabledBackgroundColor: AppColors.green.withValues(alpha: 0.4),
          textColor: Colors.black,
          icon: Icons.arrow_forward,
          onPressed: hasSelection ? widget.onContinue : null,
        ),
      ],
    );
  }
}
