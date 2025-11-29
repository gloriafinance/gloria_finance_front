import 'package:church_finance_bk/core/layout/modal_page_layout.dart';
import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/core/widgets/tag_status.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/installment_model.dart';
import '../../../models/accounts_receivable_model.dart';
import '../store/member_commitments_store.dart';
import 'payment_declaration_form.dart';

class MemberCommitmentsTable extends StatelessWidget {
  const MemberCommitmentsTable({super.key});

  InstallmentsStatus? _installmentStatus(InstallmentModel installment) {
    try {
      return InstallmentsStatus.values.firstWhere(
        (element) => element.apiValue == installment.status,
      );
    } catch (_) {
      return null;
    }
  }

  Color _installmentStatusColor(InstallmentsStatus? status) {
    switch (status) {
      case InstallmentsStatus.PAID:
        return AppColors.green;
      case InstallmentsStatus.PARTIAL:
        return AppColors.blue;
      case InstallmentsStatus.IN_REVIEW:
        return AppColors.purple;
      case InstallmentsStatus.PENDING:
      default:
        return AppColors.mustard;
    }
  }

  bool _canDeclare(InstallmentModel installment) {
    final status = _installmentStatus(installment);
    return status == null ||
        status == InstallmentsStatus.PENDING ||
        status == InstallmentsStatus.PARTIAL;
  }

  List<_CommitmentInstallmentRow> _flattenRows(
    List<AccountsReceivableModel> commitments,
  ) {
    final rows = <_CommitmentInstallmentRow>[];

    for (final commitment in commitments) {
      if (commitment.installments.isEmpty) {
        continue;
      }

      for (final installment in commitment.installments) {
        rows.add(_CommitmentInstallmentRow(commitment, installment));
      }
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<MemberCommitmentsStore>();
    final state = store.state;
    final rows = _flattenRows(state.paginate.results);

    if (state.isLoading && rows.isEmpty) {
      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 60),
        child: const CircularProgressIndicator(),
      );
    }

    if (rows.isEmpty) {
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
      headers: const ['Descrição', 'Valor da parcela', 'Vencimento', 'Status'],
      data: FactoryDataTable<_CommitmentInstallmentRow>(
        data: rows,
        dataBuilder:
            (item) => _buildRow(item as _CommitmentInstallmentRow, store),
      ),
      actionBuilders: [
        (item) {
          final row = item as _CommitmentInstallmentRow;
          if (!_canDeclare(row.installment)) {
            return const SizedBox.shrink();
          }

          return ButtonActionTable(
            color: AppColors.purple,
            text: 'Declarar pagamento',
            icon: Icons.attach_money,
            onPressed: () {
              _openDeclaration(context, row.commitment, row.installment);
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
    _CommitmentInstallmentRow row,
    MemberCommitmentsStore store,
  ) {
    final status = _installmentStatus(row.installment);

    return [
      SizedBox(
        width: 260,
        child: Text(
          row.commitment.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
        ),
      ),
      CurrencyFormatter.formatCurrency(row.installment.amount),
      convertDateFormatToDDMMYYYY(row.installment.dueDate),
      SizedBox(
        width: 140,
        child: tagStatus(
          _installmentStatusColor(status),
          store.installmentStatusLabel(row.installment.status),
        ),
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
      body: PaymentDeclarationForm(commitment: model, installment: installment),
    ).show(context).then((_) {
      context.read<MemberCommitmentsStore>().fetchCommitments();
    });
  }
}

class _CommitmentInstallmentRow {
  final AccountsReceivableModel commitment;
  final InstallmentModel installment;

  _CommitmentInstallmentRow(this.commitment, this.installment);
}
