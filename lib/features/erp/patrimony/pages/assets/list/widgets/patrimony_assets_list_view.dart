import 'package:church_finance_bk/features/erp/patrimony/pages/assets/list/widgets/patrimony_assets_filters.dart';
import 'package:church_finance_bk/features/erp/patrimony/pages/assets/list/widgets/patrimony_assets_table.dart';
import 'package:flutter/material.dart';

class PatrimonyAssetsListView extends StatelessWidget {
  const PatrimonyAssetsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        PatrimonyAssetsFilters(),
        SizedBox(height: 24),
        PatrimonyAssetsTable(),
      ],
    );
  }
}
