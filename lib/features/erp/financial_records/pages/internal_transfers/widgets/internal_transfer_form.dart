import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/core/widgets/loading.dart';
import 'package:gloria_finance/features/auth/pages/login/store/auth_session_store.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/models/availability_account_model.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';

import '../store/internal_transfer_form_store.dart';

class InternalTransferForm extends StatefulWidget {
  const InternalTransferForm({super.key});

  @override
  State<InternalTransferForm> createState() => _InternalTransferFormState();
}

class _InternalTransferFormState extends State<InternalTransferForm> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final storeAuth = Provider.of<AuthSessionStore>(context, listen: false);
      final store = Provider.of<InternalTransferFormStore>(
        context,
        listen: false,
      );

      store.setSymbolFormatMoney(storeAuth.state.session.symbolFormatMoney);
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<InternalTransferFormStore>();
    final availabilityAccountStore =
        context.watch<AvailabilityAccountsListStore>();

    final accounts = availabilityAccountStore.state.availabilityAccounts
        .where((a) => a.accountType != AccountType.INVESTMENT.apiValue)
        .toList(growable: false);

    return Form(
      key: formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _fromAccountDropdown(context, accounts, store)),
              const SizedBox(width: 12),
              Expanded(child: _toAccountDropdown(context, accounts, store)),
            ],
          ),
          Row(
            children: [
              Expanded(child: _dateInput(context, store)),
              const SizedBox(width: 12),
              Expanded(child: _amountInput(context, store)),
            ],
          ),
          _descriptionInput(context, store),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 300,
              child:
                  store.state.makeRequest
                      ? const Loading()
                      : CustomButton(
                        text:
                            context.l10n.finance_records_transfer_action_create,
                        backgroundColor: AppColors.green,
                        textColor: Colors.black,
                        onPressed: () => _save(context, store),
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fromAccountDropdown(
    BuildContext context,
    List<AvailabilityAccountModel> accounts,
    InternalTransferFormStore store,
  ) {
    return Dropdown(
      label: context.l10n.finance_records_transfer_field_from_account,
      items: accounts.map((a) => a.accountName).toList(),
      onChanged: (value) {
        final selected = accounts.firstWhere((a) => a.accountName == value);
        store.setFromAvailabilityAccountId(selected.availabilityAccountId);
        store.setSymbolFormatMoney(selected.symbol);
      },
    );
  }

  Widget _toAccountDropdown(
    BuildContext context,
    List<AvailabilityAccountModel> accounts,
    InternalTransferFormStore store,
  ) {
    return Dropdown(
      label: context.l10n.finance_records_transfer_field_to_account,
      items: accounts.map((a) => a.accountName).toList(),
      onChanged: (value) {
        final selected = accounts.firstWhere((a) => a.accountName == value);
        store.setToAvailabilityAccountId(selected.availabilityAccountId);
      },
    );
  }

  Widget _dateInput(BuildContext context, InternalTransferFormStore store) {
    return Input(
      label: context.l10n.finance_records_form_field_date,
      keyboardType: TextInputType.number,
      initialValue: store.state.date,
      onChanged: (_) {},
      onTap: () {
        selectDate(context).then((picked) {
          if (picked == null) return;
          store.setDate(convertDateFormatToDDMMYYYY(picked.toString()));
        });
      },
    );
  }

  Widget _amountInput(BuildContext context, InternalTransferFormStore store) {
    final symbol =
        store.state.symbolFormatMoney.isEmpty
            ? 'R\$'
            : store.state.symbolFormatMoney;

    return Input(
      label: context.l10n.finance_records_table_header_amount,
      keyboardType: TextInputType.number,
      inputFormatters: [CurrencyFormatter.getInputFormatters(symbol)],
      onChanged: (value) {
        final cleanedValue = value
            .replaceAll(RegExp(r'[^\d,]'), '')
            .replaceAll(',', '.');
        store.setAmount(double.tryParse(cleanedValue) ?? 0);
      },
    );
  }

  Widget _descriptionInput(
    BuildContext context,
    InternalTransferFormStore store,
  ) {
    return Input(
      label: context.l10n.finance_records_form_field_description,
      initialValue: store.state.description,
      onChanged: store.setDescription,
      maxLines: 2,
    );
  }

  void _save(BuildContext context, InternalTransferFormStore store) async {
    if (store.state.fromAvailabilityAccountId.isEmpty ||
        store.state.toAvailabilityAccountId.isEmpty ||
        store.state.date.isEmpty ||
        store.state.amount <= 0) {
      Toast.showMessage(
        context.l10n.finance_records_transfer_error_required_fields,
        ToastType.warning,
      );
      return;
    }

    if (store.state.fromAvailabilityAccountId ==
        store.state.toAvailabilityAccountId) {
      Toast.showMessage(
        context.l10n.finance_records_transfer_error_same_account,
        ToastType.warning,
      );
      return;
    }

    final success = await store.send();

    if (!context.mounted) return;

    if (success) {
      Toast.showMessage(
        context.l10n.finance_records_transfer_success_created,
        ToastType.info,
      );
      context.go('/financial-record/internal-transfer');
    }
  }
}
