import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/widgets/index.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/layout/layout_dashboard.dart';
import 'store/suppliers_list_store.dart';
import 'widgets/suppliers_table.dart';

class ListSuppliersScreen extends StatelessWidget {
  const ListSuppliersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SuppliersListStore(),
      child: LayoutDashboard(
        Builder(builder: (context) => _header(context)),
        screen: SuppliersTable(),
      ),
    );
  }

  Widget _header(BuildContext context) {
    if (!isMobile(context)) {
      return Row(
        children: [
          Expanded(
            child: Text(
              'Fornecedores',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: AppFonts.fontTitle,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(children: [_newRecord(context)]),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fornecedores',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Row(children: [Expanded(child: _newRecord(context))]),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _newRecord(BuildContext context) {
    return ButtonActionTable(
      color: AppColors.purple,
      text: "Registrar",
      onPressed: () => GoRouter.of(context).go('/suppliers/register'),
      icon: Icons.add_chart,
    );
  }
}
