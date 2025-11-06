import 'package:church_finance_bk/core/layout/modal_page_layout.dart';
import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/core/widgets/tag_status.dart';
import 'package:church_finance_bk/finance/bank_statements/models/bank_statement_model.dart';
import 'package:church_finance_bk/finance/bank_statements/store/bank_statement_list_store.dart';
import 'package:church_finance_bk/helpers/index.dart';
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
      return Container(
        margin: const EdgeInsets.only(top: 60.0),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.greyLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(Icons.account_balance, size: 48, color: AppColors.grey),
            SizedBox(height: 12),
            Text(
              'Nenhum extrato importado ainda.',
              style: TextStyle(fontFamily: AppFonts.fontSubTitle),
            ),
            SizedBox(height: 4),
            Text(
              'Importe um arquivo CSV para iniciar a conciliação bancária.',
              style: TextStyle(color: AppColors.grey),
            ),
          ],
        ),
      );
    }

    return CustomTable(
      headers: const [
        'Data',
        'Banco',
        'Descrição',
        'Valor',
        'Direção',
        'Status',
        // 'Lançamento',
      ],
      data: FactoryDataTable<dynamic>(
        data: state.statements,
        dataBuilder: (dynamic item) => _buildRow(item as BankStatementModel),
      ),
      actionBuilders: [
        (statement) => ButtonActionTable(
          color: AppColors.blue,
          text: 'Detalhes',
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
                    ? 'Processando'
                    : 'Reprocessar',
            icon: Icons.restart_alt,
            onPressed: () async {
              if (state.isRetrying(model.bankStatementId)) return;
              final response = await context
                  .read<BankStatementListStore>()
                  .retryStatement(model.bankStatementId);

              final message =
                  response.matched
                      ? 'Extrato conciliado automaticamente.'
                      : 'Nenhum lançamento correspondente encontrado.';

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
                    ? 'Vinculando...'
                    : 'Vincular',
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
      title: 'Detalhes do extrato bancário',
      body: BankStatementDetailView(statement: statement),
    ).show(context);
  }

  Future<void> _openManualLink(
    BuildContext context,
    BankStatementModel statement,
  ) async {
    final store = context.read<BankStatementListStore>();

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return BankStatementManualLinkDialog(
          statement: statement,
          onSubmit: (financialRecordId) async {
            await store.linkStatement(
              bankStatementId: statement.bankStatementId,
              financialRecordId: financialRecordId,
            );
          },
        );
      },
    );

    if (result == true) {
      Toast.showMessage('Extrato vinculado com sucesso.', ToastType.info);
    }
  }
}
