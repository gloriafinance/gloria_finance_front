import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/utils/currency_formatter.dart';
import 'package:church_finance_bk/core/widgets/index.dart';
import 'package:church_finance_bk/features/erp//settings/availability_accounts/models/availability_account_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/account_style.dart';
import '../store/monthly_tithes_list_store.dart';

class CardsSummaryTithes extends StatelessWidget {
  const CardsSummaryTithes({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<MonthlyTithesListStore>();

    var cardStyle = getCardAccountStyle(AccountType.BANK.apiValue);

    return SingleChildScrollView(
      child: SizedBox(
        height: 190,
        child: ListView(
          scrollDirection: Axis.horizontal,
          //mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CardAmount(
              title: 'Total de dízimos',
              amount: store.state.data.total,
              symbol: CurrencyType.REAL.apiValue,
              bgColor: cardStyle.color,
              icon: cardStyle.icon,
            ),
            SizedBox(width: 20),
            CardAmount(
              title: 'Dízimos de dízimos',
              amount: store.state.data.tithesOfTithes,
              symbol: CurrencyType.REAL.apiValue,
              bgColor: cardStyle.color,
              icon: cardStyle.icon,
            ),
          ],
        ),
      ),
    );
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
                fontSize: 18,
              ),
            ),
            Center(
              child: Text(
                CurrencyFormatter.formatCurrency(amount),
                textAlign: TextAlign.left,
                style: TextStyle(fontFamily: AppFonts.fontTitle, fontSize: 44),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
