import 'package:flutter/material.dart';

import 'patrimony_assets_filters.dart';
import 'patrimony_assets_table.dart';

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
