import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/accounts_receivable_model.dart';
import '../store/member_commitments_store.dart';

class MemberCommitmentsFilters extends StatelessWidget {
  const MemberCommitmentsFilters({super.key});

  List<String> _options() {
    return [
      'Todos',
      AccountsReceivableStatus.PENDING.friendlyName,
      AccountsReceivableStatus.PAID.friendlyName,
      AccountsReceivableStatus.PENDING_ACCEPTANCE.friendlyName,
      AccountsReceivableStatus.DENIED.friendlyName,
    ];
  }

  AccountsReceivableStatus? _mapFriendlyToStatus(String? friendly) {
    if (friendly == null || friendly == 'Todos') return null;
    return AccountsReceivableStatus.values
        .firstWhere((element) => element.friendlyName == friendly);
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<MemberCommitmentsStore>();
    final selectedLabel =
        store.state.filter.status?.friendlyName ?? 'Todos';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            SizedBox(
              width: 260,
              child: Dropdown(
                label: 'Status',
                items: _options(),
                initialValue: selectedLabel,
                onChanged: (value) {
                  final parsed = _mapFriendlyToStatus(value);
                  store.setStatusFilter(parsed);
                },
              ),
            ),
            ButtonActionTable(
              color: AppColors.blue,
              text: 'Aplicar filtros',
              icon: Icons.search,
              onPressed: () => store.fetchCommitments(),
            ),
          ],
        ),
      ],
    );
  }
}
