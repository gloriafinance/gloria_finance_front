import 'package:church_finance_bk/core/app_router.dart';
import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/finance/pages/financial_records/widgets/form_financial_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/form_financial_record_inputs.dart';

class AddFinancialRecordScreen extends ConsumerWidget {
  const AddFinancialRecordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Toast.init(context);

    if (bankStore.state.banks.isEmpty) {
      bankStore.searchBanks();
    }

    return LayoutDashboard(
      Row(
        children: [
          GestureDetector(
            onTap: () => ref.read(appRouterProvider).go("/financial-record"),
            child: Icon(
              Icons.arrow_back_ios,
              color: AppColors.purple,
            ),
          ),
          Text(
            'Registro financeiro',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: AppFonts.fontMedium,
              fontSize: 24,
              color: Colors.black,
            ),
          )
        ],
      ),
      screen: FormFinancialRecord(),
    );
  }
}
