import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
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
      child: LayoutDashboard(
        Row(
          children: [
            GestureDetector(
              onTap: () => context.go('/cost-center'),
              child: const Icon(Icons.arrow_back_ios, color: AppColors.purple),
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
        screen: CostCenterForm(isEdit: isEdit),
      ),
    );
  }
}
