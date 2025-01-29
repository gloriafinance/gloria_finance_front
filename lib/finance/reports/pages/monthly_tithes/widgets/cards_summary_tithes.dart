import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/monthly_tithes_list_store.dart';

class CardsSummaryTithes extends StatelessWidget {
  const CardsSummaryTithes({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<MonthlyTithesListStore>();
    return SingleChildScrollView(
        child: SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _totalIncome('Total de dizimos',
              double.parse(store.state.data.total.toString())),
          _totalIncome('Dizimos de dizmos',
              double.parse(store.state.data.tithesOfTithes.toString())),
        ],
      ),
    ));
  }

  Widget _totalIncome(String title, double amount) {
    return Card(
        color: AppColors.green,
        //surfaceTintColor: AppColors.purple,
        shadowColor: AppColors.green,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: AppFonts.fontSubTitle,
                      color: Colors.white,
                      fontSize: 18),
                ),
                Center(
                    child: Text(
                  formatCurrency(amount),
                  textAlign: TextAlign.left,
                  style:
                      TextStyle(fontFamily: AppFonts.fontTitle, fontSize: 44),
                )),
              ],
            )));
  }
}
