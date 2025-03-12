import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/form_add_availability_account.dart';

class AvailabilityAccountsScreen extends StatelessWidget {
  const AvailabilityAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutDashboard(
      Row(
        children: [
          GestureDetector(
            onTap: () => context.go("/availability-accounts"),
            child: Icon(
              Icons.arrow_back_ios,
              color: AppColors.purple,
            ),
          ),
          Text(
            'Cadastro de conta de desponibilidade',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 18,
              color: Colors.black,
            ),
          )
        ],
      ),
      screen: FromAddAvailabilityAccount(),
    );
  }
}
