import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../store/form_finance_record_store.dart';
import 'widgets/form_finance_record.dart';

class AddFinancialRecordScreen extends StatelessWidget {
  const AddFinancialRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FormFinanceRecordStore())
        ],
        child: LayoutDashboard(
          Row(
            children: [
              GestureDetector(
                onTap: () => context.go("/financial-record"),
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
                  fontSize: 18,
                  color: Colors.black,
                ),
              )
            ],
          ),
          screen: FormFinanceRecord(),
        ));
  }
}
