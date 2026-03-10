import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/features/erp/financial_records/models/internal_transfer_constants.dart';
import 'package:gloria_finance/features/erp/financial_records/pages/financial_records/store/finance_record_paginate_store.dart';
import 'package:gloria_finance/features/erp/financial_records/pages/financial_records/widgets/finance_record_table.dart';

class InternalTransferListScreen extends StatelessWidget {
  const InternalTransferListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final store = FinanceRecordPaginateStore();
            store.setReferenceType(transferReferenceTypeSource);
            store.searchFinanceRecords();
            return store;
          },
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),
          const FinanceRecordTable(internalTransferMode: true),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.go("/financial-record"),
          child: const Icon(Icons.arrow_back_ios, color: AppColors.purple),
        ),
        Expanded(
          child: Text(
            context.l10n.finance_records_transfer_list_title,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        ButtonActionTable(
          color: AppColors.green,
          text: context.l10n.finance_records_transfer_action_new,
          onPressed:
              () => GoRouter.of(
                context,
              ).go('/financial-record/internal-transfer/add'),
          icon: Icons.add,
        ),
      ],
    );
  }
}
