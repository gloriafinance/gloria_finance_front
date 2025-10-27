import 'package:church_finance_bk/core/layout/modal_page_layout.dart';
import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/widgets/button_acton_table.dart';
import 'package:church_finance_bk/patrimony/models/patrimony_inventory_import_result.dart';
import 'package:church_finance_bk/patrimony/pages/assets/list/store/patrimony_assets_list_store.dart';
import 'package:church_finance_bk/patrimony/pages/assets/list/widgets/patrimony_inventory_import_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatrimonyInventoryReportsMenu extends StatefulWidget {
  final PatrimonyAssetsListStore store;

  const PatrimonyInventoryReportsMenu({super.key, required this.store});

  @override
  State<PatrimonyInventoryReportsMenu> createState() =>
      _PatrimonyInventoryReportsMenuState();
}

enum _InventoryReportOption { csv, pdf }

class _PatrimonyInventoryReportsMenuState
    extends State<PatrimonyInventoryReportsMenu> {
  final GlobalKey _buttonKey = GlobalKey();

  Future<void> _showMenu() async {
    final RenderBox buttonBox =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final Rect buttonRect = Rect.fromPoints(
      buttonBox.localToGlobal(Offset.zero, ancestor: overlay),
      buttonBox.localToGlobal(
        buttonBox.size.bottomRight(Offset.zero),
        ancestor: overlay,
      ),
    );

    final selection = await showMenu<_InventoryReportOption>(
      context: context,
      position: RelativeRect.fromRect(
        buttonRect,
        Offset.zero & overlay.size,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: const [
        PopupMenuItem<_InventoryReportOption>(
          value: _InventoryReportOption.csv,
          child: _InventoryMenuItem(
            icon: Icons.table_chart_outlined,
            label: 'Exportar inventário (CSV)',
          ),
        ),
        PopupMenuItem<_InventoryReportOption>(
          value: _InventoryReportOption.pdf,
          child: _InventoryMenuItem(
            icon: Icons.picture_as_pdf_outlined,
            label: 'Exportar inventário (PDF)',
          ),
        ),
      ],
    );

    if (!mounted || selection == null) {
      return;
    }

    switch (selection) {
      case _InventoryReportOption.csv:
        await _handleSummaryDownload('csv');
        break;
      case _InventoryReportOption.pdf:
        await _handleSummaryDownload('pdf');
        break;
    }
  }

  Future<void> _handleSummaryDownload(String format) async {
    final success = await widget.store.downloadInventorySummary(format);
    if (!mounted) return;

    if (success) {
      Toast.showMessage('Relatório de inventário gerado.', ToastType.info);
    } else {
      Toast.showMessage('Não foi possível gerar o relatório.', ToastType.warning);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = widget.store.downloadingSummary;

    return AbsorbPointer(
      absorbing: isLoading,
      child: ButtonActionTable(
        key: _buttonKey,
        color: AppColors.purple,
        text: isLoading ? 'Gerando relatório...' : 'Exportar inventário',
        icon: isLoading ? Icons.hourglass_top : Icons.download_outlined,
        onPressed: _showMenu,
      ),
    );
  }
}

class PatrimonyInventoryChecklistButton extends StatelessWidget {
  final PatrimonyAssetsListStore store;

  const PatrimonyInventoryChecklistButton({super.key, required this.store});

  Future<void> _handleChecklistDownload(BuildContext context) async {
    final success = await store.downloadPhysicalChecklist();
    if (!context.mounted) return;

    if (success) {
      Toast.showMessage('Checklist gerado com sucesso.', ToastType.info);
    } else {
      Toast.showMessage('Não foi possível gerar o checklist.', ToastType.warning);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = store.downloadingChecklist;

    return AbsorbPointer(
      absorbing: isLoading,
      child: ButtonActionTable(
        color: AppColors.mustard,
        text: isLoading ? 'Gerando checklist...' : 'Checklist físico (CSV)',
        icon: isLoading ? Icons.hourglass_top : Icons.fact_check_outlined,
        onPressed: () => _handleChecklistDownload(context),
      ),
    );
  }
}

class PatrimonyInventoryImportButton extends StatelessWidget {
  final PatrimonyAssetsListStore store;

  const PatrimonyInventoryImportButton({super.key, required this.store});

  Future<void> _openImportDialog(BuildContext context) async {
    final result = await ModalPage(
      title: 'Importar checklist físico',
      width: 520,
      body: ChangeNotifierProvider.value(
        value: store,
        child: const PatrimonyInventoryImportDialog(),
      ),
    ).show<PatrimonyInventoryImportResult>(context);

    if (!context.mounted || result == null) {
      return;
    }

    final message =
        'Importação concluída. Processados: ${result.processed}, atualizados: ${result.updated}, ';
    final details =
        'ignorados: ${result.skipped}, erros: ${result.errors}.';
    final toastType = result.errors > 0 ? ToastType.warning : ToastType.info;

    Toast.showMessage('$message$details', toastType);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = store.importingInventory;

    return AbsorbPointer(
      absorbing: isLoading,
      child: ButtonActionTable(
        color: AppColors.blue,
        text:
            isLoading ? 'Importando checklist...' : 'Importar checklist preenchido',
        icon: isLoading ? Icons.hourglass_top : Icons.upload_file_outlined,
        onPressed: () => _openImportDialog(context),
      ),
    );
  }
}

class _InventoryMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InventoryMenuItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.purple),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
