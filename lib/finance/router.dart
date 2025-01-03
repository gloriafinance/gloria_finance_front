import 'package:church_finance_bk/core/theme/transition_custom.dart';
import 'package:church_finance_bk/finance/pages/contributions/contributions_screen.dart';
import 'package:church_finance_bk/finance/pages/financial_records/add_financial_record_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'pages/financial_records/financial_record_screen.dart';

List<Map<String, dynamic>> financialMenuItems = const [
  {
    "label": "Finanzas",
    "icon": Icons.monetization_on,
    "items": [
      {
        "label": "Contribuiçōes",
        "icon": Icons.bar_chart,
        "to": "/contributions"
      },
      {
        "label": "Registro financeiros",
        "icon": Icons.money,
        "to": "/financial-record"
      },
    ],
  },
];

financialRouter() {
  return <RouteBase>[
    GoRoute(
      path: '/financial-record',
      pageBuilder: (context, state) {
        return transitionCustom(FinancialRecordScreen());
      },
    ),
    GoRoute(
      path: '/financial-record/add',
      pageBuilder: (context, state) {
        return transitionCustom(AddFinancialRecordScreen());
      },
    ),
    GoRoute(
      path: '/contributions',
      pageBuilder: (context, state) {
        return transitionCustom(ContributionsScreen());
      },
    ),
  ];
}
