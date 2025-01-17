import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'store/purchase_register_form_store.dart';
import 'widgets/form_purchase.dart';

class AddPurchaseScreen extends StatelessWidget {
  const AddPurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PurchaseRegisterFormStore())
      ],
      child: MaterialApp(
        home: LayoutDashboard(_header(context), screen: FormPurchase()),
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
