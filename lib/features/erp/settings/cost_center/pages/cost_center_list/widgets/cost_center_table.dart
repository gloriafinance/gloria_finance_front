import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/core/widgets/tag_status.dart';
import 'package:church_finance_bk/features/erp//settings/cost_center/models/cost_center_model.dart';
import 'package:church_finance_bk/features/erp//settings/cost_center/store/cost_center_list_store.dart';
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
        child: const Center(
          child: Text(
            'Nenhum centro de custo cadastrado.',
            style: TextStyle(fontFamily: AppFonts.fontText),
          ),
        ),
      );
    }

    return CustomTable(
      headers: const ['Código', 'Nome', 'Categoria', 'Responsável', 'Status'],
      data: FactoryDataTable<CostCenterModel>(
        data: state.costCenters,
        dataBuilder: (costCenter) => _mapToRow(costCenter as CostCenterModel),
      ),
      actionBuilders: [
        (costCenter) => ButtonActionTable(
          color: AppColors.blue,
          text: 'Editar',
          onPressed:
              () => _navigateToEdit(context, costCenter as CostCenterModel),
          icon: Icons.edit_outlined,
        ),
      ],
    );
  }

  List<dynamic> _mapToRow(CostCenterModel costCenter) {
    final responsible = costCenter.responsible;

    return [
      costCenter.costCenterId,
      costCenter.name,
      costCenter.category.friendlyName,
      responsible != null && responsible.name.isNotEmpty
          ? responsible.name
          : '—',
      costCenter.active
          ? tagStatus(AppColors.green, 'Ativo')
          : tagStatus(Colors.red, 'Inativo'),
    ];
  }

  void _navigateToEdit(BuildContext context, CostCenterModel costCenter) {
    GoRouter.of(
      context,
    ).go('/cost-center/edit/${costCenter.costCenterId}', extra: costCenter);
  }
}
