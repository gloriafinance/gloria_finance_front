import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/pages/availability_accounts/store/form_availability_store.dart';
import 'package:gloria_finance/features/erp/settings/banks/store/bank_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'widgets/form_add_availability_account.dart';

class AvailabilityAccountsScreen extends StatelessWidget {
  const AvailabilityAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FormAvailabilityStore()),
        ChangeNotifierProvider(create: (_) => BankStore()..searchBanks()),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => context.go("/availability-accounts"),
                child: Icon(Icons.arrow_back_ios, color: AppColors.purple),
              ),
              Text(
                context.l10n.settings_availability_form_title,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          FromAddAvailabilityAccount(),
        ],
      ),
    );
  }
}
