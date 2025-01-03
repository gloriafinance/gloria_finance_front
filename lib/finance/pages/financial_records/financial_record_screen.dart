import 'package:church_finance_bk/core/app_router.dart';
import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinancialRecordScreen extends ConsumerWidget {
  const FinancialRecordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutDashboard(
      _header(ref),
      screen: Column(
        children: [],
      ),
    );
  }

  Widget _header(WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Movimentos financeiros',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: AppFonts.fontMedium,
              fontSize: 24,
              color: Colors.black,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: _buttons(ref),
        ),
      ],
    );
  }

  Widget _buttons(WidgetRef ref) {
    return Row(
      children: [
        ButtonActionTable(
            color: AppColors.purple,
            text: "Relatório",
            onPressed: () => {},
            icon: Icons.download),
        ButtonActionTable(
            color: AppColors.purple,
            text: "Registrar",
            onPressed: () =>
                ref.read(appRouterProvider).go("/financial-record/add"),
            icon: Icons.add_chart),
      ],
    );
  }
}
