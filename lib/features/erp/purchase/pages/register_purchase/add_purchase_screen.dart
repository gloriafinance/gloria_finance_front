import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/support_assistant/widgets/open_gloria_assistance_context_button.dart';
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
        ChangeNotifierProvider(create: (_) => PurchaseRegisterFormStore()),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_header(context), FormPurchase()],
      ),
    );
  }

  Widget _header(BuildContext context) {
    const title = 'Cadastro de compras';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go("/purchase"),
                    child: Icon(Icons.arrow_back_ios, color: AppColors.purple),
                  ),
                  Text(
                    title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              OpenGloriaAssistanceContextButton(
                question:
                    context.l10n.support_assistant_context_purchase_question,
                title: 'Register purchase',
                route: '/purchase/register',
                module: 'purchases',
                summary:
                    'Screen used to register purchases with supplier, items, invoice context and financial impact.',
                relatedRoutes: const [
                  '/purchase',
                  '/suppliers/register',
                  '/financial-concepts',
                  '/availability-accounts',
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
