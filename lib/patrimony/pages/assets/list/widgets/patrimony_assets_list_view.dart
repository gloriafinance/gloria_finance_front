import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/patrimony/pages/assets/list/store/patrimony_assets_list_store.dart';
import 'package:church_finance_bk/patrimony/pages/assets/list/widgets/patrimony_assets_filters.dart';
import 'package:church_finance_bk/patrimony/pages/assets/list/widgets/patrimony_assets_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatrimonyAssetsListView extends StatelessWidget {
  const PatrimonyAssetsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        PatrimonyAssetsFilters(),
        SizedBox(height: 16),
        PatrimonyInventoryActions(),
        SizedBox(height: 24),
        PatrimonyAssetsTable(),
      ],
    );
  }
}

class PatrimonyInventoryActions extends StatelessWidget {
  const PatrimonyInventoryActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PatrimonyAssetsListStore>(
      builder: (context, store, _) {
        final buttons = <Widget>[
          _actionButton(
            context: context,
            label:
                store.downloadingSummary ? 'Gerando CSV...' : 'Exportar inventário (CSV)',
            color: AppColors.purple,
            onPressed: store.downloadingSummary
                ? null
                : () => _handleSummaryDownload(context, store, 'csv'),
          ),
          _actionButton(
            context: context,
            label:
                store.downloadingSummary ? 'Gerando PDF...' : 'Exportar inventário (PDF)',
            color: AppColors.blue,
            onPressed: store.downloadingSummary
                ? null
                : () => _handleSummaryDownload(context, store, 'pdf'),
          ),
          _actionButton(
            context: context,
            label: store.downloadingChecklist
                ? 'Gerando checklist...'
                : 'Checklist físico (CSV)',
            color: AppColors.mustard,
            textColor: Colors.black87,
            onPressed: store.downloadingChecklist
                ? null
                : () => _handleChecklistDownload(context, store),
          ),
        ];

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: buttons,
        );
      },
    );
  }

  static Widget _actionButton({
    required BuildContext context,
    required String label,
    required Color color,
    Color textColor = Colors.white,
    VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: 220,
      child: CustomButton(
        text: label,
        backgroundColor: color,
        textColor: textColor,
        onPressed: onPressed,
      ),
    );
  }

  static Future<void> _handleSummaryDownload(
    BuildContext context,
    PatrimonyAssetsListStore store,
    String format,
  ) async {
    final success = await store.downloadInventorySummary(format);
    if (!context.mounted) return;

    if (success) {
      Toast.showMessage('Relatório de inventário gerado.', ToastType.info);
    } else {
      Toast.showMessage('Não foi possível gerar o relatório.', ToastType.warning);
    }
  }

  static Future<void> _handleChecklistDownload(
    BuildContext context,
    PatrimonyAssetsListStore store,
  ) async {
    final success = await store.downloadPhysicalChecklist();
    if (!context.mounted) return;

    if (success) {
      Toast.showMessage('Checklist gerado com sucesso.', ToastType.info);
    } else {
      Toast.showMessage('Não foi possível gerar o checklist.', ToastType.warning);
    }
  }
}
