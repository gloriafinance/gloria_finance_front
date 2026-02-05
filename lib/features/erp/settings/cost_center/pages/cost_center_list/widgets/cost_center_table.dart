import 'package:gloria_finance/core/paginate/custom_table.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/core/widgets/tag_status.dart';
import 'package:gloria_finance/features/erp/settings/cost_center/models/cost_center_model.dart';
import 'package:gloria_finance/features/erp/settings/cost_center/store/cost_center_list_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CostCenterTable extends StatelessWidget {
  const CostCenterTable({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<CostCenterListStore>();
    final state = store.state;

    if (state.isLoading) {
      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 40.0),
        child: const CircularProgressIndicator(),
      );
    }

    if (state.costCenters.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 40.0),
        child: Center(
          child: Text(
            context.l10n.common_no_results_found,
            style: const TextStyle(fontFamily: AppFonts.fontText),
          ),
        ),
      );
    }

    return CustomTable(
      headers: [
        context.l10n.settings_cost_center_field_code,
        context.l10n.settings_cost_center_field_name,
        context.l10n.settings_cost_center_field_category,
        context.l10n.settings_cost_center_field_responsible,
        context.l10n.common_status,
      ],
      data: FactoryDataTable<CostCenterModel>(
        data: state.costCenters,
        dataBuilder: (costCenter) =>
            _mapToRow(context, costCenter as CostCenterModel),
      ),
      actionBuilders: [
        (costCenter) => ButtonActionTable(
          color: AppColors.blue,
          text: context.l10n.common_edit,
          onPressed:
              () => _navigateToEdit(context, costCenter as CostCenterModel),
          icon: Icons.edit_outlined,
        ),
      ],
    );
  }

  List<dynamic> _mapToRow(BuildContext context, CostCenterModel costCenter) {
    final responsible = costCenter.responsible;
    final statusLabel =
        costCenter.active
            ? context.l10n.schedule_status_active
            : context.l10n.schedule_status_inactive;

    return [
      costCenter.costCenterId,
      costCenter.name,
      costCenter.category.friendlyName(context.l10n),
      responsible != null && responsible.name.isNotEmpty
          ? responsible.name
          : '—',
      tagStatus(
        costCenter.active ? AppColors.green : Colors.red,
        statusLabel,
      ),
    ];
  }

  void _navigateToEdit(BuildContext context, CostCenterModel costCenter) {
    GoRouter.of(
      context,
    ).go('/cost-center/edit/${costCenter.costCenterId}', extra: costCenter);
  }
}
