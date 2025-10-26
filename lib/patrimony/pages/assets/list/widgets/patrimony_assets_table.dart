import 'package:church_finance_bk/core/layout/modal_page_layout.dart';
import 'package:church_finance_bk/core/paginate/custom_table.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/core/widgets/tag_status.dart';
import 'package:church_finance_bk/patrimony/models/patrimony_asset_model.dart';
import 'package:church_finance_bk/patrimony/pages/assets/detail/widgets/patrimony_asset_detail_view.dart';
import 'package:church_finance_bk/patrimony/pages/assets/list/store/patrimony_assets_list_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PatrimonyAssetsTable extends StatelessWidget {
  const PatrimonyAssetsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PatrimonyAssetsListStore>(
      builder: (context, store, _) {
        final state = store.state;

        if (state.loading) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: const CircularProgressIndicator(),
          );
        }

        if (state.hasError) {
          return Center(
            child: Column(
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: AppColors.mustard, size: 48),
                const SizedBox(height: 12),
                const Text('Não foi possível carregar os bens. Tente novamente.'),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: store.refresh,
                  child: const Text('Recarregar'),
                ),
              ],
            ),
          );
        }

        if (state.assets.results.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: const Text(
              'Nenhum bem encontrado com os filtros selecionados.',
              textAlign: TextAlign.center,
            ),
          );
        }

        return CustomTable(
          headers: const [
            'Código',
            'Nome',
            'Categoria',
            'Valor',
            'Aquisição',
            'Localização',
            'Status',
          ],
          data: FactoryDataTable(
            data: state.assets.results,
            dataBuilder: (asset) => _buildRow(context, asset as PatrimonyAssetModel),
          ),
          actionBuilders: [
            (asset) {
              final patrimony = asset as PatrimonyAssetModel;
              return ButtonActionTable(
                color: AppColors.blue,
                text: 'Visualizar',
                icon: Icons.visibility_outlined,
                onPressed: () {
                  ModalPage(
                    title: patrimony.name,
                    body: PatrimonyAssetDetailView(asset: patrimony),
                    width: 900,
                  ).show(context);
                },
              );
            },
            (asset) => ButtonActionTable(
                  color: AppColors.purple,
                  text: 'Editar',
                  icon: Icons.edit_outlined,
                  onPressed: () => context
                      .go('/patrimony/assets/${asset.assetId}/edit', extra: asset),
                ),
          ],
          paginate: PaginationData(
            totalRecords: state.assets.count,
            nextPag: state.assets.nextPag,
            perPage: state.perPage,
            currentPage: state.page,
            onNextPag: store.goToNextPage,
            onPrevPag: store.goToPreviousPage,
            onChangePerPage: store.changePerPage,
          ),
        );
      },
    );
  }

  List<dynamic> _buildRow(BuildContext context, PatrimonyAssetModel asset) {
    return [
      asset.code,
      asset.name,
      asset.categoryLabel,
      asset.valueLabel,
      asset.acquisitionDateLabel,
      asset.location?.isNotEmpty == true ? asset.location! : '-',
      _statusTag(asset),
    ];
  }

  Widget _statusTag(PatrimonyAssetModel asset) {
    final color = _statusColor(asset);
    return SizedBox(
      width: 140,
      child: tagStatus(color, asset.statusLabel),
    );
  }

  Color _statusColor(PatrimonyAssetModel asset) {
    switch (asset.status?.apiValue) {
      case 'ACTIVE':
        return AppColors.green;
      case 'MAINTENANCE':
        return AppColors.mustard;
      case 'INACTIVE':
        return AppColors.grey;
      case 'ARCHIVED':
        return AppColors.greyMiddle;
      case 'DISPOSED':
        return Colors.redAccent;
      default:
        return AppColors.purple;
    }
  }
}
