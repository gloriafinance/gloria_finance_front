import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/features/erp/settings/cost_center/store/cost_center_list_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'widgets/cost_center_table.dart';

class CostCenterListScreen extends StatefulWidget {
  const CostCenterListScreen({super.key});

  @override
  State<CostCenterListScreen> createState() => _CostCenterListScreenState();
}

class _CostCenterListScreenState extends State<CostCenterListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store = context.read<CostCenterListStore>();
      if (!store.state.isLoading && store.state.costCenters.isEmpty) {
        store.searchCostCenters();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutDashboard(
      _header(context),
      screen: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [SizedBox(height: 24), CostCenterTable()],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Centros de custo',
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 24,
              color: Colors.black,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: ButtonActionTable(
            color: AppColors.purple,
            text: 'Novo centro de custo',
            onPressed: () => GoRouter.of(context).go('/cost-center/add'),
            icon: Icons.add_box_outlined,
          ),
        ),
      ],
    );
  }
}
