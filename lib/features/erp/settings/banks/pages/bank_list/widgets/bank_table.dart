import 'package:gloria_finance/core/paginate/custom_table.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/core/widgets/tag_status.dart';
import 'package:gloria_finance/features/auth/pages/login/store/auth_session_store.dart';
import 'package:gloria_finance/features/erp/settings/banks/models/bank_model.dart';
import 'package:gloria_finance/features/erp/settings/banks/store/bank_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BankTable extends StatelessWidget {
  const BankTable({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<BankStore>();
    final state = store.state;
    final sessionStore = context.watch<AuthSessionStore>();
    final isVenezuela = sessionStore.state.session.country.toUpperCase() == 'VE';

    if (state.isLoading) {
      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 40.0),
        child: const CircularProgressIndicator(),
      );
    }

    if (state.banks.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 40.0),
        child: Center(
          child: Text(
            context.l10n.common_no_results_found,
            style: const TextStyle(fontFamily: AppFonts.fontText),
          ),
        ),
      );
    }

    return CustomTable(
      headers: _buildHeaders(context, isVenezuela),
      data: FactoryDataTable<BankModel>(
        data: state.banks,
        dataBuilder: (bank) => _mapToRow(context, bank, isVenezuela),
      ),
      actionBuilders: [
        (bank) => ButtonActionTable(
          color: AppColors.blue,
          text: context.l10n.common_edit,
          onPressed: () => _navigateToEdit(context, bank as BankModel),
          icon: Icons.edit_outlined,
        ),
      ],
    );
  }

  List<String> _buildHeaders(BuildContext context, bool isVenezuela) {
    if (isVenezuela) {
      return [
        context.l10n.settings_banks_field_name,
        context.l10n.settings_banks_field_holder_name,
        context.l10n.settings_banks_field_document_id,
        context.l10n.settings_banks_field_account_type,
        context.l10n.settings_banks_field_account,
        context.l10n.common_status,
      ];
    }

    return [
      context.l10n.settings_banks_field_name,
      context.l10n.settings_banks_field_tag,
      context.l10n.settings_banks_field_account_type,
      context.l10n.settings_banks_field_bank_code,
      context.l10n.settings_banks_field_agency,
      context.l10n.settings_banks_field_account,
      context.l10n.common_status,
    ];
  }

  List<dynamic> _mapToRow(
    BuildContext context,
    BankModel bank,
    bool isVenezuela,
  ) {
    final statusLabel =
        bank.active
            ? context.l10n.schedule_status_active
            : context.l10n.schedule_status_inactive;

    if (isVenezuela) {
      return [
        bank.name,
        bank.bankInstruction.codeBank,
        bank.bankInstruction.agency,
        bank.accountType.friendlyName,
        bank.bankInstruction.account,
        tagStatus(bank.active ? AppColors.green : Colors.red, statusLabel),
      ];
    }

    return [
      bank.name,
      bank.tag,
      bank.accountType.friendlyName,
      bank.bankInstruction.codeBank,
      bank.bankInstruction.agency,
      bank.bankInstruction.account,
      tagStatus(bank.active ? AppColors.green : Colors.red, statusLabel),
    ];
  }

  void _navigateToEdit(BuildContext context, BankModel bank) {
    GoRouter.of(context).go('/banks/edit/${bank.bankId}', extra: bank);
  }
}
