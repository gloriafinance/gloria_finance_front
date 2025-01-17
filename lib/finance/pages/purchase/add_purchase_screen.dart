import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddPurchaseScreen extends StatelessWidget {
  const AddPurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LayoutDashboard(
        _header(context),
        screen: Text('oi'),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.go("/financial-record"),
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.purple,
          ),
        ),
        Text(
          'Registrar compras',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: AppFonts.fontMedium,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
