import 'package:flutter/material.dart';
import 'package:gloria_finance/core/utils/general.dart';
import 'package:gloria_finance/features/erp/home/widgets/loans_widget.dart';

import '../../../../core/theme/index.dart';
import 'accounts_payable_widget.dart';

class FinancialCommitments extends StatelessWidget {
  const FinancialCommitments({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Compromissos Financeiros",
          style: TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 18,
            color: Colors.black,
          ),
        ),

        isMobile(context)
            ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  AccountsPayableWidget(),
                  SizedBox(width: 10),
                  LoansWidget(),
                ],
              ),
            )
            : Column(
              children: [
                AccountsPayableWidget(),
                SizedBox(width: 40),
                LoansWidget(),
              ],
            ),
      ],
    );
  }
}
