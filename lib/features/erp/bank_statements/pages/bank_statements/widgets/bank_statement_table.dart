import 'package:gloria_finance/core/layout/modal_page_layout.dart';
import 'package:gloria_finance/core/paginate/custom_table.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/core/widgets/tag_status.dart';
import 'package:gloria_finance/features/erp/bank_statements/models/bank_statement_model.dart';
import 'package:gloria_finance/features/erp/bank_statements/store/bank_statement_list_store.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'bank_statement_detail_view.dart';
import 'bank_statement_manual_link_dialog.dart';

class BankStatementTable extends StatelessWidget {
  const BankStatementTable({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<BankStatementListStore>();
    final state = store.state;

    if (state.loading && state.statements.isEmpty) {
      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 60.0),
        child: const CircularProgressIndicator(),
      );
    }

    if (state.statements.isEmpty) {
      return Center(
        child: Container(
          margin: const EdgeInsets.only(top: 60.0),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.greyLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_balance,
                size: 48,
                color: AppColors.grey,
              ),
              const SizedBox(height: 12),
              Text(
                context.l10n.bankStatements_empty_title,
                style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.bankStatements_empty_subtitle,
                style: const TextStyle(color: AppColors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return CustomTable(
      headers: [
        context.l10n.bankStatements_header_date,
        context.l10n.bankStatements_header_bank,
        context.l10n.bankStatements_header_description,
        context.l10n.bankStatements_header_amount,
        context.l10n.bankStatements_header_direction,
        context.l10n.bankStatements_header_status,
        // 'Lançamento',
      ],
      data: FactoryDataTable<dynamic>(
        data: state.statements,
        dataBuilder: (dynamic item) => _buildRow(item as BankStatementModel),
      ),
      actionBuilders: [
        (statement) => ButtonActionTable(
          color: AppColors.blue,
          text: context.l10n.bankStatements_action_details,
          icon: Icons.search,
          onPressed: () => _openDetails(context, statement),
        ),
        (statement) {
          final model = statement as BankStatementModel;
          if (model.isReconciled) {
            return const SizedBox.shrink();
          }

          return ButtonActionTable(
            color: AppColors.purple,
            text:
                state.isRetrying(model.bankStatementId)
                    ? context.l10n.common_loading
                    : context.l10n.bankStatements_action_retry,
            icon: Icons.restart_alt,
            onPressed: () async {
              if (state.isRetrying(model.bankStatementId)) return;
              final response = await context
                  .read<BankStatementListStore>()
                  .retryStatement(model.bankStatementId);

              final message =
                  response.matched
                      ? context.l10n.bankStatements_toast_auto_reconciled
                      : context.l10n.bankStatements_toast_no_match;

              Toast.showMessage(message, ToastType.info);
            },
          );
        },
        (statement) {
          final model = statement as BankStatementModel;
          if (model.isReconciled) {
            return const SizedBox.shrink();
          }

          return ButtonActionTable(
            color: Colors.deepOrange,
            text:
                state.isLinking(model.bankStatementId)
                    ? context.l10n.bankStatements_action_linking
                    : context.l10n.bankStatements_action_link,
            icon: Icons.link,
            onPressed: () {
              if (state.isLinking(model.bankStatementId)) return;
              _openManualLink(context, model);
            },
          );
        },
      ],
    );
  }

  List<dynamic> _buildRow(BankStatementModel statement) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(statement.postedAt);
    final bankName = '${statement.bank.bankName} (${statement.bank.tag})';
    final amount = CurrencyFormatter.formatCurrency(statement.amount);
    final directionIcon =
        statement.direction == BankStatementDirection.income
            ? Icons.arrow_downward_rounded
            : Icons.arrow_upward_rounded;
    final directionColor =
        statement.direction == BankStatementDirection.income
            ? AppColors.green
            : Colors.redAccent;

    return [
      formattedDate,
      Text(bankName, style: const TextStyle(fontFamily: AppFonts.fontSubTitle)),
      SizedBox(
        width: 280,
        child: Text(
          statement.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
        ),
      ),
      amount,
      Row(
        children: [
          Icon(directionIcon, size: 18, color: directionColor),
          const SizedBox(width: 6),
          Text(
            statement.direction.friendlyName,
            style: TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              color: directionColor,
            ),
          ),
        ],
      ),
      tagStatus(
        statement.reconciliationStatus.badgeColor,
        statement.reconciliationStatus.friendlyName,
      ),
      // statement.financialRecordId != null
      //     ? SelectableText(
      //       statement.financialRecordId!,
      //       style: const TextStyle(
      //         fontFamily: AppFonts.fontSubTitle,
      //         color: AppColors.blue,
      //       ),
      //     )
      //     : const Text(
      //       '-',
      //       style: TextStyle(fontFamily: AppFonts.fontSubTitle),
      //     ),
    ];
  }

  void _openDetails(BuildContext context, BankStatementModel statement) {
    ModalPage(
      title: context.l10n.bankStatements_details_title,
      body: BankStatementDetailView(statement: statement),
    ).show(context);
  }

  Future<void> _openManualLink(
    BuildContext context,
    BankStatementModel statement,
  ) async {
    final store = context.read<BankStatementListStore>();
    final l10n = context.l10n;

    final result = await ModalPage(
      title: l10n.bankStatements_link_dialog_title,
      width: 520,
      body: BankStatementManualLinkDialog(
        statement: statement,
        onSubmit: (financialRecordId) async {
          await store.linkStatement(
            bankStatementId: statement.bankStatementId,
            financialRecordId: financialRecordId,
          );
        },
      ),
    ).show<bool>(context);

    if (result == true) {
      Toast.showMessage(
        context.l10n.bankStatements_toast_link_success,
        ToastType.info,
      );
    }
  }
}
