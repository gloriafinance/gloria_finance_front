import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/finance/models/contribution_model.dart';
import 'package:flutter/material.dart';

import '../../../stores/contribution_pagination_store.dart';

final contributionPaginationStore = ContributionPaginationStore();

class ContributionFilters extends StatefulWidget {
  const ContributionFilters({super.key});

  @override
  State<ContributionFilters> createState() => _ContributionFiltersState();
}

class _ContributionFiltersState extends State<ContributionFilters> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 300,
              child: Dropdown(
                label: "Status",
                items: ContributionStatus.values
                    .map((e) => e.friendlyName)
                    .toList(),
                onChanged: (value) =>
                    contributionPaginationStore.setStatus(value),
              ),
            ),
            SizedBox(width: 10), // Espaciado entre el dropdown y el botón
            Container(
              margin: EdgeInsets.only(top: 53),
              child: CustomButton(
                text: "Filtrar",
                backgroundColor: AppColors.purple,
                width: 100,
                textColor: Colors.white,
                onPressed: () => applyFilter(),
              ),
            )
          ],
        ),
      ],
    );
  }

  void applyFilter() {
    contributionPaginationStore.apply();
  }
}
