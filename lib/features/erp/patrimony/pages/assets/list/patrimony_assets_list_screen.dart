import 'package:church_finance_bk/core/layout/layout_dashboard.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/features/erp/patrimony/pages/assets/list/store/patrimony_assets_list_store.dart';
import 'package:church_finance_bk/features/erp/patrimony/pages/assets/list/widgets/patrimony_assets_list_view.dart';
import 'package:church_finance_bk/features/erp/patrimony/pages/assets/list/widgets/patrimony_inventory_reports_menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PatrimonyAssetsListScreen extends StatelessWidget {
  const PatrimonyAssetsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PatrimonyAssetsListStore()..loadAssets(),
      child: LayoutDashboard(
        Builder(builder: (context) => _header(context)),
        screen: const PatrimonyAssetsListView(),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final title = Text(
      'Patrimônio',
      textAlign: TextAlign.left,
      style: TextStyle(
        fontFamily: AppFonts.fontTitle,
        fontSize: 20,
        color: Colors.black,
      ),
    );

    return Consumer<PatrimonyAssetsListStore>(
      builder: (context, store, _) {
        final registerButton = ButtonActionTable(
          color: AppColors.purple,
          text: 'Registrar bem',
          icon: Icons.add_circle_outline,
          onPressed: () => context.go('/patrimony/assets/new'),
        );

        final actions = Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            registerButton,
            PatrimonyInventoryImportButton(store: store),
            PatrimonyInventoryReportsMenu(store: store),
            PatrimonyInventoryChecklistButton(store: store),
          ],
        );

        if (!isMobile(context)) {
          return Row(children: [Expanded(child: title), actions]);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            const SizedBox(height: 16),
            actions,
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }
}
