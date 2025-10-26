import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:church_finance_bk/patrimony/models/patrimony_asset_enums.dart';
import 'package:church_finance_bk/patrimony/pages/assets/list/store/patrimony_assets_list_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatrimonyAssetsFilters extends StatelessWidget {
  const PatrimonyAssetsFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PatrimonyAssetsListStore>(
      builder: (context, store, _) {
        final statusItems = PatrimonyAssetStatus.values.map((e) => e.label).toList();
        final categoryItems = PatrimonyAssetCategory.values.map((e) => e.label).toList();

        final actionButtons = Row(
          children: [
            if (!isMobile(context))
              CustomButton(
                text: 'Aplicar filtros',
                backgroundColor: AppColors.purple,
                textColor: Colors.white,
                onPressed: store.applyFilters,
              )
            else
              Expanded(
                child: CustomButton(
                  text: 'Aplicar filtros',
                  backgroundColor: AppColors.purple,
                  textColor: Colors.white,
                  onPressed: store.applyFilters,
                ),
              ),
            const SizedBox(width: 12),
            if (!isMobile(context))
              CustomButton(
                text: 'Limpar',
                backgroundColor: AppColors.greyLight,
                textColor: Colors.white,
                onPressed: store.clearFilters,
              )
            else
              Expanded(
                child: CustomButton(
                  text: 'Limpar',
                  backgroundColor: AppColors.greyLight,
                  textColor: Colors.white,
                  onPressed: store.clearFilters,
                ),
              ),
          ],
        );

        if (isMobile(context)) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Input(
                label: 'Buscar',
                initialValue: store.state.search,
                iconRight: const Icon(Icons.search, color: AppColors.purple),
                onIconTap: store.applySearch,
                onChanged: store.setSearch,
              ),
              Dropdown(
                label: 'Status',
                initialValue: store.statusLabel,
                items: statusItems,
                onChanged: (value) => store.setStatusByLabel(value?.isEmpty == true ? null : value),
                labelSuffix: _clearFilterButton(
                  visible: store.state.status != null,
                  onPressed: () => store.setStatusByLabel(null),
                ),
              ),
              Dropdown(
                label: 'Categoria',
                initialValue: store.categoryLabel,
                items: categoryItems,
                onChanged: (value) => store.setCategoryByLabel(value?.isEmpty == true ? null : value),
                labelSuffix: _clearFilterButton(
                  visible: store.state.category != null,
                  onPressed: () => store.setCategoryByLabel(null),
                ),
              ),
              Input(
                label: 'Congregação (churchId)',
                initialValue: store.state.churchId,
                onChanged: store.setChurch,
              ),
              const SizedBox(height: 12),
              actionButtons,
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Input(
                    label: 'Buscar',
                    initialValue: store.state.search,
                    iconRight:
                        const Icon(Icons.search, color: AppColors.purple),
                    onIconTap: store.applySearch,
                    onChanged: store.setSearch,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Dropdown(
                    label: 'Status',
                    initialValue: store.statusLabel,
                    items: statusItems,
                    onChanged: (value) =>
                        store.setStatusByLabel(value?.isEmpty == true ? null : value),
                    labelSuffix: _clearFilterButton(
                      visible: store.state.status != null,
                      onPressed: () => store.setStatusByLabel(null),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Dropdown(
                    label: 'Categoria',
                    initialValue: store.categoryLabel,
                    items: categoryItems,
                    onChanged: (value) => store
                        .setCategoryByLabel(value?.isEmpty == true ? null : value),
                    labelSuffix: _clearFilterButton(
                      visible: store.state.category != null,
                      onPressed: () => store.setCategoryByLabel(null),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Input(
                    label: 'Congregação (churchId)',
                    initialValue: store.state.churchId,
                    onChanged: store.setChurch,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(child: SizedBox()),
                const SizedBox(width: 16),
                Expanded(child: SizedBox()),
              ],
            ),
            const SizedBox(height: 16),
            actionButtons,
          ],
        );
      },
    );
  }

  Widget _clearFilterButton({required bool visible, required VoidCallback onPressed}) {
    if (!visible) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onPressed,
      child: const Icon(
        Icons.close,
        size: 18,
        color: AppColors.greyMiddle,
      ),
    );
  }
}
