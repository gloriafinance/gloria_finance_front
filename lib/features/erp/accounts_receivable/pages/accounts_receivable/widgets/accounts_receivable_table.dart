import 'package:gloria_finance/core/paginate/custom_table.dart';
import 'package:gloria_finance/core/theme/index.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/index.dart';
import 'package:gloria_finance/features/auth/pages/login/store/auth_session_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../models/index.dart';
import '../store/accounts_receivable_store.dart';

class AccountsReceivableTable extends StatelessWidget {
  const AccountsReceivableTable({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AccountsReceivableStore>(context);
    final state = store.state;
    final l10n = context.l10n;

    if (state.makeRequest) {
      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 40.0),
        child: CircularProgressIndicator(),
      );
    }

    if (state.paginate.results.isEmpty) {
      return Center(child: Text(l10n.accountsReceivable_table_empty));
    }

    return Container(
      margin: isMobile(context) ? null : const EdgeInsets.only(top: 40.0),
      child: CustomTable(
        headers: [
          l10n.accountsReceivable_table_header_debtor,
          l10n.accountsReceivable_table_header_description,
          l10n.accountsReceivable_table_header_type,
          l10n.accountsReceivable_table_header_installments,
          l10n.accountsReceivable_table_header_received,
          l10n.accountsReceivable_table_header_pending,
          l10n.accountsReceivable_table_header_total,
          l10n.accountsReceivable_table_header_status,
        ],
        data: FactoryDataTable<AccountsReceivableModel>(
          data: state.paginate.results,
          dataBuilder: accountsReceivableDTO,
        ),
        paginate: PaginationData(
          totalRecords: state.paginate.count,
          nextPag: state.paginate.nextPag,
          perPage: state.paginate.perPage,
          currentPage: state.filter.page,
          onNextPag: () {
            store.nextPage();
          },
          onPrevPag: () {
            store.prevPage();
          },
          onChangePerPage: (perPage) {
            store.setPerPage(perPage);
          },
        ),
        actionBuilders: [
          (accountsReceivable) => ButtonActionTable(
            color: AppColors.blue,
            text: l10n.accountsReceivable_table_action_view,
            onPressed: () => _openDetail(context, accountsReceivable),
            icon: Icons.remove_red_eye_sharp,
          ),
        ],
      ),
    );
  }

  void _openDetail(
    BuildContext context,
    AccountsReceivableModel accountsReceivable,
  ) {
    context.go('/account-receivables/view', extra: accountsReceivable);
  }

  List<dynamic> accountsReceivableDTO(dynamic accountsReceivable) {
    final model = accountsReceivable as AccountsReceivableModel;

    String statusLabel = '-';
    if (model.status != null) {
      try {
        statusLabel =
            AccountsReceivableStatus.values
                .firstWhere((e) => e.toString().split('.').last == model.status)
                .friendlyName;
      } catch (_) {
        statusLabel = model.status ?? '-';
      }
    }

    return [
      model.debtor.name,
      model.description,
      model.type?.friendlyName ?? '-',
      model.installments.length.toString(),
      CurrencyFormatter.formatCurrency(
        model.amountPaid ?? 0,
        symbol: model.symbol,
      ),
      CurrencyFormatter.formatCurrency(
        model.amountPending ?? 00,
        symbol: model.symbol,
      ),
      CurrencyFormatter.formatCurrency(
        model.amountTotal ?? 00,
        symbol: model.symbol,
      ),
      tagStatus(getStatusColor(model.status ?? ''), statusLabel),
    ];
  }
}
