import 'package:gloria_finance/core/theme/index.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/features/erp/financial_records/models/finance_record_export_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/finance_record_paginate_store.dart';

class FinanceRecordExportButton extends StatefulWidget {
  const FinanceRecordExportButton({super.key});

  @override
  State<FinanceRecordExportButton> createState() =>
      _FinanceRecordExportButtonState();
}

enum _FinanceRecordExportOption { csv, pdf }

class _FinanceRecordExportButtonState extends State<FinanceRecordExportButton> {
  final GlobalKey _buttonKey = GlobalKey();

  Future<void> _showMenu() async {
    final renderObject = _buttonKey.currentContext?.findRenderObject();
    final overlayObject = Overlay.of(context).context.findRenderObject();

    if (renderObject is! RenderBox || overlayObject is! RenderBox) {
      return;
    }

    final buttonRect = Rect.fromPoints(
      renderObject.localToGlobal(Offset.zero, ancestor: overlayObject),
      renderObject.localToGlobal(
        renderObject.size.bottomRight(Offset.zero),
        ancestor: overlayObject,
      ),
    );

    final selection = await showMenu<_FinanceRecordExportOption>(
      context: context,
      position: RelativeRect.fromRect(
        buttonRect,
        Offset.zero & overlayObject.size,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: const [
        PopupMenuItem<_FinanceRecordExportOption>(
          value: _FinanceRecordExportOption.csv,
          child: _FinanceRecordExportMenuItem(
            icon: Icons.table_chart_outlined,
            label: 'Exportar como CSV',
          ),
        ),
        PopupMenuItem<_FinanceRecordExportOption>(
          value: _FinanceRecordExportOption.pdf,
          child: _FinanceRecordExportMenuItem(
            icon: Icons.picture_as_pdf_outlined,
            label: 'Exportar como PDF',
          ),
        ),
      ],
    );

    if (!mounted || selection == null) {
      return;
    }

    switch (selection) {
      case _FinanceRecordExportOption.csv:
        await _handleExport(FinanceRecordExportFormat.csv);
        break;
      case _FinanceRecordExportOption.pdf:
        await _handleExport(FinanceRecordExportFormat.pdf);
        break;
    }
  }

  Future<void> _handleExport(FinanceRecordExportFormat format) async {
    final store = context.read<FinanceRecordPaginateStore>();
    final result = await store.exportFinanceRecords(format);

    if (!mounted || result) {
      return;
    }

    Toast.showMessage(
      "Error al exportar los registros financieros",
      ToastType.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isExporting = context.select<FinanceRecordPaginateStore, bool>(
      (store) => store.exporting,
    );

    return AbsorbPointer(
      absorbing: isExporting,
      child: ButtonActionTable(
        key: _buttonKey,
        color: AppColors.blue,
        text: isExporting ? 'Exportando...' : 'Exportar',
        icon: isExporting ? Icons.hourglass_top : Icons.download_outlined,
        onPressed: _showMenu,
      ),
    );
  }
}

class _FinanceRecordExportMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FinanceRecordExportMenuItem({required this.icon, required this.label});

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
