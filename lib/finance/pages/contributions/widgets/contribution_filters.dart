import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/finance/models/contribution_model.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';

import '../store/contribution_pagination_store.dart';

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
      children: [
        _dropdownStatus(),
        SizedBox(height: 10),
        _buttonApplyFilter(),
      ],
    );
  }

  Widget _layoutDesktop() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 300,
              child: _dropdownStatus(),
            ),
            SizedBox(width: 10), // Espaciado entre el dropdown y el botón
            Container(
              margin: EdgeInsets.only(top: 48),
              child: _buttonApplyFilter(),
            )
          ],
        ),
      ],
    );
  }

  Widget _buttonApplyFilter() {
    return CustomButton(
      text: "Filtrar",
      backgroundColor: AppColors.purple,
      textColor: Colors.white,
      onPressed: () => applyFilter(),
    );
  }

  Widget _dropdownStatus() {
    return Dropdown(
      label: "Status",
      items: ContributionStatus.values.map((e) => e.friendlyName).toList(),
      onChanged: (value) => contributionPaginationStore.setStatus(value),
    );
  }

  void applyFilter() {
    contributionPaginationStore.apply();
  }
}
