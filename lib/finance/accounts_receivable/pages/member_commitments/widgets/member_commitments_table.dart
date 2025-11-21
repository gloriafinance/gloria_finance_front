import 'package:church_finance_bk/core/layout/modal_page_layout.dart';
import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/core/widgets/tag_status.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/installment_model.dart';
import '../../../models/accounts_receivable_model.dart';
import '../store/member_commitments_store.dart';
import 'payment_declaration_form.dart';

class MemberCommitmentsTable extends StatelessWidget {
  const MemberCommitmentsTable({super.key});

  AccountsReceivableStatus? _statusFromModel(AccountsReceivableModel model) {
    return AccountsReceivableStatusHelper.fromApiValue(model.status);
  }

  Color _statusColor(AccountsReceivableStatus? status) {
    switch (status) {
      case AccountsReceivableStatus.PAID:
        return AppColors.green;
      case AccountsReceivableStatus.PENDING_ACCEPTANCE:
        return AppColors.blue;
      case AccountsReceivableStatus.DENIED:
        return Colors.redAccent;
      case AccountsReceivableStatus.PENDING:
      default:
        return AppColors.mustard;
    }
  }

  InstallmentModel? _nextPendingInstallment(AccountsReceivableModel model) {
    for (final installment in model.installments) {
      if (installment.status == InstallmentsStatus.PENDING.apiValue ||
          installment.status == InstallmentsStatus.PARTIAL.apiValue ||
          installment.status == null) {
        return installment;
      }
    }
    return null;
  }

  bool _canDeclare(AccountsReceivableModel model) {
    return _nextPendingInstallment(model) != null;
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<MemberCommitmentsStore>();
    final state = store.state;

    if (state.isLoading && state.paginate.results.isEmpty) {
      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 60),
        child: const CircularProgressIndicator(),
      );
    }

    if (state.paginate.results.isEmpty) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 32),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.greyLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Nenhum compromisso encontrado.',
              style: TextStyle(fontFamily: AppFonts.fontTitle, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Quando houver parcelas pendentes, você poderá declarar o pagamento por aqui.',
              style: TextStyle(fontFamily: AppFonts.fontSubTitle),
            ),
          ],
        ),
      );
    }

    return CustomTable(
      headers: const [
        'Descrição',
        'Próxima parcela',
        'Vencimento',
        'Status',
      ],
      data: FactoryDataTable<AccountsReceivableModel>(
        data: state.paginate.results,
        dataBuilder: (item) => _buildRow(item as AccountsReceivableModel, store),
      ),
      actionBuilders: [
        (item) {
          final model = item as AccountsReceivableModel;
          final pendingInstallment = _nextPendingInstallment(model);
          if (!_canDeclare(model)) {
            return const SizedBox.shrink();
          }

          return ButtonActionTable(
            color: AppColors.purple,
            text: 'Declarar pagamento',
            icon: Icons.attach_money,
            onPressed: () {
              if (pendingInstallment != null) {
                _openDeclaration(context, model, pendingInstallment);
              }
            },
          );
        },
      ],
      paginate: PaginationData(
        totalRecords: state.paginate.count,
        nextPag: state.paginate.nextPag,
        perPage: state.paginate.perPage,
        currentPage: state.filter.page,
        onNextPag: () => store.setPage(state.filter.page + 1),
        onPrevPag: () => store.setPage(state.filter.page - 1),
        onChangePerPage: (value) => store.setPerPage(value),
      ),
    );
  }

  List<dynamic> _buildRow(
    AccountsReceivableModel model,
    MemberCommitmentsStore store,
  ) {
    final pendingInstallment = _nextPendingInstallment(model);
    final status = _statusFromModel(model);

    return [
      SizedBox(
        width: 260,
        child: Text(
          model.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
        ),
      ),
      pendingInstallment != null
          ? CurrencyFormatter.formatCurrency(pendingInstallment.amount)
          : CurrencyFormatter.formatCurrency(model.amountPending ?? 0),
      pendingInstallment != null
          ? convertDateFormatToDDMMYYYY(pendingInstallment.dueDate)
          : '-',
      SizedBox(
        width: 140,
        child: tagStatus(_statusColor(status), store.statusLabel(model.status)),
      ),
    ];
  }

  void _openDeclaration(
    BuildContext context,
    AccountsReceivableModel model,
    InstallmentModel installment,
  ) {
    ModalPage(
      title: 'Declarar pagamento',
      body: PaymentDeclarationForm(
        commitment: model,
        installment: installment,
      ),
    ).show(context).then((_) {
      context.read<MemberCommitmentsStore>().fetchCommitments();
    });
  }
}
