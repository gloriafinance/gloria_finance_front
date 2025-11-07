import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:church_finance_bk/patrimony/models/patrimony_asset_enums.dart';
import 'package:church_finance_bk/patrimony/pages/assets/list/store/patrimony_assets_list_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatrimonyAssetsFilters extends StatefulWidget {
  const PatrimonyAssetsFilters({super.key});

  @override
  State<PatrimonyAssetsFilters> createState() => _PatrimonyAssetsFiltersState();
}

class _PatrimonyAssetsFiltersState extends State<PatrimonyAssetsFilters> {
  bool _isExpandedFilter = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<PatrimonyAssetsListStore>(
      builder: (context, store, _) {
        final statusItems = PatrimonyAssetStatusCollection.labels();
        final categoryItems =
            PatrimonyAssetCategory.values.map((e) => e.label).toList();

        return isMobile(context)
            ? _mobileLayout(store, statusItems, categoryItems)
            : _desktopLayout(store, statusItems, categoryItems);
      },
    );
  }

  Widget _mobileLayout(
    PatrimonyAssetsListStore store,
    List<String> statusItems,
    List<String> categoryItems,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: ExpansionPanelList(
        expansionCallback: (index, isExpanded) {
          setState(() {
            _isExpandedFilter = !_isExpandedFilter;
          });
        },
        animationDuration: const Duration(milliseconds: 500),
        children: [
          ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: _isExpandedFilter,
            headerBuilder: (context, isOpen) {
              return ListTile(
                title: Text(
                  'FILTROS',
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: AppFonts.fontTitle,
                    color: AppColors.purple,
                  ),
                ),
              );
            },
            body: Column(
              children: [
                Row(children: [Expanded(child: _searchInput(store))]),
                Row(
                  children: [
                    Expanded(child: _statusDropdown(store, statusItems)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _categoryDropdown(store, categoryItems)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _isExpandedFilter = false;
                          });
                          store.clearFilters();
                        },
                        child: const Text('Limpar filtros'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ButtonActionTable(
                        color: AppColors.blue,
                        text: 'Aplicar filtros',
                        icon: Icons.search,
                        onPressed: () {
                          setState(() {
                            _isExpandedFilter = false;
                          });
                          store.applyFilters();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _desktopLayout(
    PatrimonyAssetsListStore store,
    List<String> statusItems,
    List<String> categoryItems,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _searchInput(store)),
            const SizedBox(width: 16),
            Expanded(child: _statusDropdown(store, statusItems)),
            const SizedBox(width: 16),
            Expanded(child: _categoryDropdown(store, categoryItems)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: store.clearFilters,
              child: const Text('Limpar filtros'),
            ),
            const SizedBox(width: 12),
            ButtonActionTable(
              color: AppColors.blue,
              text: 'Aplicar filtros',
              icon: Icons.search,
              onPressed: store.applyFilters,
            ),
          ],
        ),
      ],
    );
  }

  Widget _searchInput(PatrimonyAssetsListStore store) {
    return Input(
      label: 'Buscar',
      initialValue: store.state.search,
      iconRight: const Icon(Icons.search, color: AppColors.purple),
      onIconTap: store.applySearch,
      onChanged: store.setSearch,
    );
  }

  Widget _statusDropdown(
    PatrimonyAssetsListStore store,
    List<String> statusItems,
  ) {
    return Dropdown(
      label: 'Status',
      initialValue: store.statusLabel,
      items: statusItems,
      onChanged:
          (value) =>
              store.setStatusByLabel(value?.isEmpty == true ? null : value),
      labelSuffix: _clearFilterButton(
        visible: store.state.status != null,
        onPressed: () => store.setStatusByLabel(null),
      ),
    );
  }

  Widget _categoryDropdown(
    PatrimonyAssetsListStore store,
    List<String> categoryItems,
  ) {
    return Dropdown(
      label: 'Categoria',
      initialValue: store.categoryLabel,
      items: categoryItems,
      onChanged:
          (value) =>
              store.setCategoryByLabel(value?.isEmpty == true ? null : value),
      labelSuffix: _clearFilterButton(
        visible: store.state.category != null,
        onPressed: () => store.setCategoryByLabel(null),
      ),
    );
  }

  Widget _clearFilterButton({
    required bool visible,
    required VoidCallback onPressed,
  }) {
    if (!visible) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onPressed,
      child: const Icon(Icons.close, size: 18, color: AppColors.greyMiddle),
    );
  }
}
