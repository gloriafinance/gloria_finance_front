import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/support_assistant/widgets/open_gloria_assistance_context_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/cost_center_model.dart';
import 'store/cost_center_form_store.dart';
import 'widgets/cost_center_form.dart';

class CostCenterFormScreen extends StatelessWidget {
  final CostCenterModel? costCenter;

  const CostCenterFormScreen({super.key, this.costCenter});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    final isEdit = costCenter != null;
    final title =
        isEdit ? 'Editar centro de custo' : 'Cadastrar centro de custo';

    return ChangeNotifierProvider(
      create: (_) => CostCenterFormStore(costCenter: costCenter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => context.go('/cost-center'),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.purple,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          OpenGloriaAssistanceContextButton(
            question:
                context.l10n.support_assistant_context_cost_center_question,
            title: title,
            route: '/cost-center/add',
            module: 'finance_configuration',
            summary:
                'Screen used to configure a cost center for expense, ministry or project classification.',
            relatedRoutes: const [
              '/cost-center',
              '/financial-record/add',
              '/purchase/register',
            ],
            extraData: {'mode': isEdit ? 'edit' : 'create'},
          ),
          const SizedBox(height: 12),
          CostCenterForm(isEdit: isEdit),
        ],
      ),
    );
  }
}
