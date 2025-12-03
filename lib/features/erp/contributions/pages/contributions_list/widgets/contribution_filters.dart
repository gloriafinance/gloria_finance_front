import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/features/erp/contributions/models/contribution_model.dart';
import 'package:flutter/material.dart';

import '../../../helpers/contribution.helper.dart';
import '../../../store/contribution_pagination_store.dart';

final contributionPaginationStore = ContributionPaginationStore();

class ContributionFilters extends StatefulWidget {
  const ContributionFilters({super.key});

  @override
  State<ContributionFilters> createState() => _ContributionFiltersState();
}

class _ContributionFiltersState extends State<ContributionFilters> {
  @override
  Widget build(BuildContext context) {
    return isMobile(context) ? _layoutMobile() : _layoutDesktop();
  }

  Widget _layoutMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_dropdownStatus(), SizedBox(height: 10), _buttonApplyFilter()],
    );
  }

  Widget _layoutDesktop() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 300, child: _dropdownStatus()),
            SizedBox(width: 10), // Espaciado entre el dropdown y el botón
            Container(
              margin: EdgeInsets.only(top: 48),
              child: _buttonApplyFilter(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buttonApplyFilter() {
    return ButtonActionTable(
      color: AppColors.blue,
      text: context.l10n.common_apply_filters,
      icon: Icons.search,
      onPressed: () => applyFilter(),
    );
  }

  Widget _dropdownStatus() {
    final statuses = ContributionStatus.values;
    final List<String> labels =
        statuses
            .map(
              (status) => getContributionStatusLabel(context, status),
            )
            .toList(growable: false);

    return Dropdown(
      label: context.l10n.common_status,
      items: labels,
      onChanged: (value) {
        final index = labels.indexOf(value);
        if (index >= 0) {
          contributionPaginationStore.setStatus(statuses[index]);
        }
      },
    );
  }

  void applyFilter() {
    contributionPaginationStore.apply();
  }
}
