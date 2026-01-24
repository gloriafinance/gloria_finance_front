import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'store/purchase_paginate_store.dart';
import 'widgets/purchase_table.dart';

class PurchaseListScreen extends StatelessWidget {
  const PurchaseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PurchasePaginateStore()..searchPurchases(),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),

          //children: [PurchaseFilters(), PurchaseTable()],
          PurchaseTable(),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    if (!isMobile(context)) {
      return Row(
        children: [
          Expanded(
            child: Text(
              'Lista de compras',
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
            child: Row(children: [_newPurchase(context)]),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lista de compras',
          style: TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Row(children: [Expanded(child: _newPurchase(context))]),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _newPurchase(BuildContext context) {
    return ButtonActionTable(
      color: AppColors.purple,
      text: "Registrar compra",
      onPressed: () => GoRouter.of(context).go('/purchase/register'),
      icon: Icons.sell_outlined,
    );
  }
}
