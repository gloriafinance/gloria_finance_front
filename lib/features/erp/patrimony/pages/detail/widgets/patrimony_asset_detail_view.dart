import 'dart:math' as math;
import 'dart:typed_data';

import 'package:gloria_finance/core/layout/modal_page_layout.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/features/erp/patrimony/models/patrimony_asset_model.dart';
import 'package:gloria_finance/features/erp/patrimony/models/patrimony_history_entry.dart';
import 'package:gloria_finance/features/erp/settings/members/store/member_all_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../list/store/patrimony_assets_list_store.dart';
import '../store/patrimony_asset_detail_store.dart';
import 'patrimony_asset_disposal_dialog.dart';
import 'patrimony_asset_inventory_dialog.dart';

class PatrimonyAssetDetailView extends StatelessWidget {
  final PatrimonyAssetModel asset;

  const PatrimonyAssetDetailView({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PatrimonyAssetDetailStore(asset: asset),
      child: const _PatrimonyAssetDetailBody(),
    );
  }

  static String resolveResponsible(
    MemberAllStore memberStore,
    PatrimonyAssetModel asset,
  ) {
    if (asset.responsibleId == null || asset.responsibleId!.isEmpty) {
      return '-';
    }

    for (final member in memberStore.getMembers()) {
      if (member.memberId == asset.responsibleId) {
        return member.name;
      }
    }

    return asset.responsibleId ?? '-';
  }
}

class _PatrimonyAssetDetailBody extends StatelessWidget {
  const _PatrimonyAssetDetailBody();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Consumer2<MemberAllStore, PatrimonyAssetDetailStore>(
        builder: (context, memberStore, detailStore, _) {
          final asset = detailStore.asset;
          final responsibleName = PatrimonyAssetDetailView.resolveResponsible(
            memberStore,
            asset,
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _PatrimonyDetailTabs(
                asset: asset,
                store: detailStore,
                responsibleName: responsibleName,
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}

class _PatrimonyDetailTabs extends StatelessWidget {
  final PatrimonyAssetModel asset;
  final PatrimonyAssetDetailStore store;
  final String responsibleName;

  const _PatrimonyDetailTabs({
    required this.asset,
    required this.store,
    required this.responsibleName,
  });

  @override
  Widget build(BuildContext context) {
    final tabController = DefaultTabController.of(context)!;

    final detailContent = _detailTabContent(
      context,
      asset,
      store,
      responsibleName,
    );
    final historyContent = _historyTabContent(context, asset);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            labelColor: AppColors.purple,
            unselectedLabelColor: AppColors.grey,
            indicator: BoxDecoration(
              color: AppColors.purple.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontWeight: FontWeight.w600,
            ),
            tabs: [
              Tab(text: context.l10n.patrimony_asset_detail_tab_details),
              Tab(text: context.l10n.patrimony_asset_detail_tab_history),
            ],
          ),

          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: tabController,
            builder: (context, _) {
              return IndexedStack(
                index: tabController.index,
                children: [detailContent, historyContent],
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget _detailTabContent(
  BuildContext context,
  PatrimonyAssetModel asset,
  PatrimonyAssetDetailStore store,
  String responsibleName,
) {
  final sections = <Widget>[
    _summaryCard(context, asset, store, responsibleName),
  ];

  void addSection(Widget section) {
    sections
      ..add(const SizedBox(height: 24))
      ..add(section);
  }

  if (asset.hasDisposal) {
    addSection(_disposalSection(asset));
  }

  if (asset.inventoryStatus != null ||
      asset.inventoryCheckedAt != null ||
      (asset.inventoryNotes?.isNotEmpty ?? false)) {
    addSection(_inventorySection(asset));
  }

  addSection(_attachmentsSection(context, asset));

  sections.add(const SizedBox(height: 8));

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: sections,
  );
}

Widget _historyTabContent(BuildContext context, PatrimonyAssetModel asset) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [_historySection(context, asset), const SizedBox(height: 8)],
  );
}

Widget _summaryCard(
  BuildContext context,
  PatrimonyAssetModel asset,
  PatrimonyAssetDetailStore store,
  String responsibleName,
) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final isCompact = constraints.maxWidth < 720;
      final columnWidth =
          isCompact
              ? constraints.maxWidth
              : math.min(340.0, (constraints.maxWidth - 16) / 2).toDouble();

      final entries = [
        _InfoEntry(
          label: context.l10n.patrimony_asset_detail_category,
          value: asset.categoryLabel,
        ),
        _InfoEntry(
          label: context.l10n.patrimony_asset_detail_quantity,
          value: asset.quantityLabel.isNotEmpty ? asset.quantityLabel : '-',
        ),
        _InfoEntry(
          label: context.l10n.patrimony_asset_detail_acquisition_date,
          value:
              asset.acquisitionDateLabel.isEmpty
                  ? '-'
                  : asset.acquisitionDateLabel,
        ),
        _InfoEntry(
          label: context.l10n.patrimony_asset_detail_location,
          value: asset.location?.isNotEmpty == true ? asset.location! : '-',
        ),
        _InfoEntry(
          label: context.l10n.patrimony_asset_detail_responsible,
          value: responsibleName,
        ),
        _InfoEntry(
          label: context.l10n.patrimony_asset_detail_pending_documents,
          valueWidget: _buildPendingBadge(context, asset),
        ),
        _InfoEntry(
          label: context.l10n.patrimony_asset_detail_notes,
          value: asset.notes?.isNotEmpty == true ? asset.notes! : '-',
          fullWidth: true,
        ),
      ];

      final metadataBadges = <Widget>[];
      if (asset.code.isNotEmpty) {
        metadataBadges.add(
          _metaBadge(
            icon: Icons.confirmation_number_outlined,
            label: asset.code,
            color: AppColors.blue,
          ),
        );
      }
      if (asset.quantity > 0) {
        metadataBadges.add(
          _metaBadge(
            icon: Icons.inventory_2_outlined,
            label: context
                .l10n.patrimony_asset_detail_quantity_badge(asset.quantity),
            color: AppColors.mustard,
          ),
        );
      }
      if (asset.valueLabel.isNotEmpty) {
        metadataBadges.add(
          _metaBadge(
            icon: Icons.attach_money,
            label: asset.valueLabel,
            color: AppColors.green,
          ),
        );
      }
      if (asset.statusLabel.isNotEmpty) {
        metadataBadges.add(
          _metaBadge(
            icon: Icons.flag_outlined,
            label: asset.statusLabel,
            color: _statusColor(asset),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.schedule_outlined,
                          size: 16,
                          color: AppColors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          asset.updatedAt != null
                              ? context.l10n.patrimony_asset_detail_updated_at(
                                  _formatDate(asset.updatedAt!),
                                )
                              : context
                                  .l10n.patrimony_asset_detail_updated_at('-'),
                          style: const TextStyle(color: AppColors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!isCompact) _editButton(context, asset),
            ],
          ),
          if (isCompact) ...[
            const SizedBox(height: 16),
            _editButton(context, asset, fullWidth: true),
          ],
          if (metadataBadges.isNotEmpty) ...[
            const SizedBox(height: 20),
            Wrap(spacing: 12, runSpacing: 12, children: metadataBadges),
          ],
          const SizedBox(height: 16),
          _actionButtons(context, asset, store),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children:
                entries.map((entry) {
                  final width =
                      (entry.fullWidth || isCompact)
                          ? constraints.maxWidth
                          : columnWidth;
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: width,
                      maxWidth: width,
                    ),
                    child: _InfoTile(entry: entry),
                  );
                }).toList(),
          ),
        ],
      );
    },
  );
}

Widget _actionButtons(
  BuildContext context,
  PatrimonyAssetModel asset,
  PatrimonyAssetDetailStore store,
) {
  final buttons = <Widget>[];
  final inventoryLabel =
      (asset.inventoryStatus == null &&
              asset.inventoryCheckedAt == null &&
              (asset.inventoryNotes?.isEmpty ?? true))
          ? context.l10n.patrimony_asset_detail_inventory_register
          : context.l10n.patrimony_asset_detail_inventory_update;

  buttons.add(
    SizedBox(
      width: 230,
      child: CustomButton(
        text:
            store.registeringInventory
                ? context.l10n.common_processing
                : inventoryLabel,
        icon: Icons.published_with_changes_sharp,
        backgroundColor: AppColors.blue,
        textColor: Colors.white,
        onPressed:
            store.registeringInventory
                ? null
                : () => _openInventoryDialog(context, store),
      ),
    ),
  );

  if (!asset.hasDisposal) {
    buttons.add(
      SizedBox(
        width: 230,
        child: CustomButton(
          icon: Icons.delete_forever_outlined,
          text:
              store.registeringDisposal
                  ? context.l10n.common_processing
                  : context.l10n.patrimony_asset_detail_disposal_register,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          onPressed:
              store.registeringDisposal
                  ? null
                  : () => _openDisposalDialog(context, store),
        ),
      ),
    );
  }

  return Wrap(spacing: 12, runSpacing: 12, children: buttons);
}

Future<void> _openInventoryDialog(
  BuildContext context,
  PatrimonyAssetDetailStore store,
) async {
  final success = await ModalPage(
    title: context.l10n.patrimony_asset_detail_inventory_modal_title,
    width: 520,
    body: ChangeNotifierProvider.value(
      value: store,
      child: const PatrimonyAssetInventoryDialog(),
    ),
  ).show<bool>(context);

  if (success == true) {
    if (!context.mounted) return;
    context.read<PatrimonyAssetsListStore>().updateAssetEntry(store.asset);
    Toast.showMessage(
      context.l10n.patrimony_asset_detail_inventory_success,
      ToastType.info,
    );
  }
}

Future<void> _openDisposalDialog(
  BuildContext context,
  PatrimonyAssetDetailStore store,
) async {
  final success = await ModalPage(
    title: context.l10n.patrimony_asset_detail_disposal_modal_title,
    width: 520,
    body: ChangeNotifierProvider.value(
      value: store,
      child: const PatrimonyAssetDisposalDialog(),
    ),
  ).show<bool>(context);

  if (success == true) {
    if (!context.mounted) return;
    context.read<PatrimonyAssetsListStore>().updateAssetEntry(store.asset);
    Toast.showMessage(
      context.l10n.patrimony_asset_detail_disposal_success,
      ToastType.info,
    );
  }
}

Widget _disposalSection(PatrimonyAssetModel asset) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final isCompact = constraints.maxWidth < 720;
      final columnWidth =
          isCompact
              ? constraints.maxWidth
              : math.min(360.0, (constraints.maxWidth - 16) / 2).toDouble();

      final entries = [
        _InfoEntry(
          label: context.l10n.patrimony_asset_detail_disposal_status,
          value: asset.disposalStatusLabel,
        ),
        _InfoEntry(
          label: context.l10n.patrimony_asset_detail_disposal_reason,
          value:
              asset.disposalReason?.isNotEmpty == true
                  ? asset.disposalReason!
                  : '-',
          fullWidth: true,
        ),
        _InfoEntry(
          label: context.l10n.patrimony_asset_detail_disposal_date,
          value:
              asset.disposalDateLabel.isEmpty ? '-' : asset.disposalDateLabel,
        ),
        _InfoEntry(
          label: context.l10n.patrimony_asset_detail_disposal_performed_by,
          value:
              asset.disposalPerformedBy?.isNotEmpty == true
                  ? asset.disposalPerformedBy!
                  : '-',
        ),
        _InfoEntry(
          label: context.l10n.patrimony_asset_detail_notes,
          value:
              asset.disposalNotes?.isNotEmpty == true
                  ? asset.disposalNotes!
                  : '-',
          fullWidth: true,
        ),
      ];

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.patrimony_asset_detail_disposal_success,
              style: const TextStyle(
                fontFamily: AppFonts.fontTitle,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children:
                  entries.map((entry) {
                    final width =
                        (entry.fullWidth || isCompact)
                            ? constraints.maxWidth
                            : columnWidth;
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: width,
                        maxWidth: width,
                      ),
                      child: _InfoTile(entry: entry),
                    );
                  }).toList(),
            ),
          ],
        ),
      );
    },
  );
}

Widget _inventorySection(PatrimonyAssetModel asset) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final isCompact = constraints.maxWidth < 720;
      final columnWidth =
          isCompact
              ? constraints.maxWidth
              : math.min(360.0, (constraints.maxWidth - 16) / 2).toDouble();

      final inventoryCheckedByName = asset.inventoryCheckedBy?.name ?? '';

      final entries = [
        _InfoEntry(
          label: context.l10n.patrimony_asset_detail_inventory_result,
          value:
              asset.inventoryStatusLabel.isEmpty
                  ? '-'
                  : asset.inventoryStatusLabel,
        ),
        _InfoEntry(
          label: context.l10n.patrimony_asset_detail_inventory_checked_at,
          value:
              asset.inventoryCheckedAtLabel.isEmpty
                  ? '-'
                  : asset.inventoryCheckedAtLabel,
        ),
        _InfoEntry(
          label: context.l10n.patrimony_asset_detail_inventory_checked_by,
          value:
              inventoryCheckedByName.isNotEmpty ? inventoryCheckedByName : '-',
        ),
        _InfoEntry(
          label: context.l10n.patrimony_asset_detail_notes,
          value:
              asset.inventoryNotes?.isNotEmpty == true
                  ? asset.inventoryNotes!
                  : '-',
          fullWidth: true,
        ),
      ];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.patrimony_asset_detail_inventory_title,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children:
                entries.map((entry) {
                  final width =
                      (entry.fullWidth || isCompact)
                          ? constraints.maxWidth
                          : columnWidth;
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: width,
                      maxWidth: width,
                    ),
                    child: _InfoTile(entry: entry),
                  );
                }).toList(),
          ),
        ],
      );
    },
  );
}

Widget _attachmentsSection(BuildContext context, PatrimonyAssetModel asset) {
  if (asset.attachments.isEmpty) {
    return Text(
      context.l10n.patrimony_asset_detail_attachments_empty,
      style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
    );
  }

  return LayoutBuilder(
    builder: (context, constraints) {
      final isCompact = constraints.maxWidth < 640;
      final attachmentsCount = asset.attachments.length;
      final crossAxisCount =
          isCompact
              ? 1
              : (attachmentsCount >= 3 ? 3 : math.max(1, attachmentsCount));
      const spacing = 16.0;
      final cardWidth =
          isCompact
              ? constraints.maxWidth
              : ((constraints.maxWidth - spacing * (crossAxisCount - 1)) /
                      crossAxisCount)
                  .clamp(0, constraints.maxWidth)
                  .toDouble();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.patrimony_asset_detail_attachments_title,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children:
                asset.attachments.map((attachment) {
                  final isImage = attachment.mimetype.toLowerCase().startsWith(
                    'image/',
                  );
                  final isPdf = attachment.mimetype.toLowerCase().contains(
                    'pdf',
                  );
                  return _AttachmentCard(
                    width: cardWidth,
                    name: attachment.name,
                    sizeLabel: attachment.formattedSize,
                    uploadedLabel: attachment.uploadedAtLabel,
                    preview:
                        isImage
                            ? _AttachmentPreview.network(attachment.url)
                            : const Icon(
                              Icons.insert_drive_file,
                              color: AppColors.purple,
                              size: 42,
                            ),
                    actionLabel:
                        isPdf
                            ? context
                                .l10n.patrimony_asset_detail_attachment_view_pdf
                            : context
                                .l10n.patrimony_asset_detail_attachment_open,
                    onView: () => _openUrl(attachment.url),
                    onPreviewTap:
                        isImage
                            ? () => _showImageDialog(
                              context,
                              Image.network(
                                attachment.url,
                                fit: BoxFit.contain,
                              ),
                            )
                            : null,
                  );
                }).toList(),
          ),
        ],
      );
    },
  );
}

Widget _historySection(
  BuildContext context,
  PatrimonyAssetModel asset, {
  bool showHeader = true,
}) {
  if (asset.history.isEmpty) {
    return Text(
      context.l10n.patrimony_asset_detail_history_empty,
      style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
    );
  }

  final entries = asset.history;

  Widget buildEntries() {
    if (entries.length <= 4) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < entries.length; i++) ...[
            _buildHistoryCard(context, entries[i]),
            if (i != entries.length - 1) const SizedBox(height: 12),
          ],
        ],
      );
    }

    return _HistoryScrollableList(entries: entries);
  }

  if (!showHeader) {
    return buildEntries();
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        context.l10n.patrimony_asset_detail_history_title,
        style: const TextStyle(fontFamily: AppFonts.fontTitle, fontSize: 18),
      ),
      const SizedBox(height: 12),
      buildEntries(),
    ],
  );
}

class _HistoryScrollableList extends StatefulWidget {
  final List<PatrimonyHistoryEntry> entries;

  const _HistoryScrollableList({required this.entries});

  @override
  State<_HistoryScrollableList> createState() => _HistoryScrollableListState();
}

class _HistoryScrollableListState extends State<_HistoryScrollableList> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entries = widget.entries;
    final maxHeight = math.min<double>(600, entries.length * 128.0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyMiddle),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: maxHeight,
        child: Scrollbar(
          controller: _controller,
          thumbVisibility: true,
          child: ListView.separated(
            controller: _controller,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) =>
                _buildHistoryCard(context, entries[index]),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: entries.length,
          ),
        ),
      ),
    );
  }
}

Widget _buildHistoryCard(BuildContext context, PatrimonyHistoryEntry entry) {
  final changes = entry.formattedChanges;
  final hasNotes = entry.notes?.isNotEmpty == true;
  final hasChanges = changes.isNotEmpty;

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.greyMiddle),
      color: Colors.white,
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.purple.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.history,
                color: AppColors.purple,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.action,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontSubTitle,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (entry.performedAtLabel.isNotEmpty)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.schedule,
                              size: 16,
                              color: AppColors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              entry.performedAtLabel,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      if (entry.performedBy?.isNotEmpty == true)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.person_outline,
                              size: 16,
                              color: AppColors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              entry.performedBy!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (hasNotes || hasChanges) const SizedBox(height: 12),
        if (hasNotes)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.patrimony_asset_detail_notes,
                style: const TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                entry.notes!,
                style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
              ),
            ],
          ),
        if (hasNotes && hasChanges) const SizedBox(height: 12),
        if (hasChanges)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.patrimony_asset_detail_history_changes_title,
                style: const TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              ...changes.map(
                (change) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• '),
                      Expanded(
                        child: Text(
                          change,
                          style: const TextStyle(
                            fontFamily: AppFonts.fontSubTitle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ],
    ),
  );
}

Widget _buildPendingBadge(BuildContext context, PatrimonyAssetModel asset) {
  final pending = asset.documentsPending;
  final color = pending ? AppColors.mustard : AppColors.green;
  final icon =
      pending ? Icons.warning_amber_outlined : Icons.check_circle_outline;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Text(
          pending
              ? context.l10n.patrimony_asset_detail_yes
              : context.l10n.patrimony_asset_detail_no,
          style: TextStyle(fontFamily: AppFonts.fontSubTitle, color: color),
        ),
      ],
    ),
  );
}

Widget _editButton(
  BuildContext context,
  PatrimonyAssetModel asset, {
  bool fullWidth = false,
}) {
  final button = CustomButton(
    text: context.l10n.common_edit,
    icon: Icons.edit_note_rounded,
    typeButton: CustomButton.outline,
    backgroundColor: AppColors.purple,
    textColor: AppColors.purple,
    onPressed: () {
      Navigator.of(context).pop();
      context.go('/patrimony/assets/${asset.assetId}/edit', extra: asset);
    },
  );

  if (fullWidth) {
    return SizedBox(width: double.infinity, child: button);
  }

  return button;
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
    case 'DONATED':
    case 'SOLD':
    case 'LOST':
    case 'DISPOSED':
      return Colors.redAccent;
    default:
      return AppColors.purple;
  }
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  final year = date.year.toString();
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$day/$month/$year • $hour:$minute';
}

Future<void> _showImageDialog(BuildContext context, Widget image) async {
  await showDialog<void>(
    context: context,
    builder: (context) {
      return Dialog(child: InteractiveViewer(maxScale: 4, child: image));
    },
  );
}

Future<void> _openUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

Widget _metaBadge({
  required IconData icon,
  required String label,
  required Color color,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontFamily: AppFonts.fontSubTitle,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

class _InfoEntry {
  final String label;
  final String? value;
  final Widget? valueWidget;
  final bool fullWidth;

  _InfoEntry({
    required this.label,
    this.value,
    this.valueWidget,
    this.fullWidth = false,
  });
}

class _InfoTile extends StatelessWidget {
  final _InfoEntry entry;

  const _InfoTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyMiddle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry.label,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          entry.valueWidget ??
              Text(
                entry.value ?? '-',
                style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
              ),
        ],
      ),
    );
  }
}

class _AttachmentCard extends StatelessWidget {
  final double width;
  final String name;
  final String sizeLabel;
  final String uploadedLabel;
  final Widget preview;
  final String actionLabel;
  final VoidCallback onView;
  final VoidCallback? onPreviewTap;

  const _AttachmentCard({
    required this.width,
    required this.name,
    required this.sizeLabel,
    required this.uploadedLabel,
    required this.preview,
    required this.actionLabel,
    required this.onView,
    this.onPreviewTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyMiddle),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onPreviewTap,
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.greyMiddle.withOpacity(0.2),
              ),
              alignment: Alignment.center,
              child: preview,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sizeLabel,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            uploadedLabel,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onView,
              child: Text(actionLabel.toUpperCase()),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttachmentPreview extends StatelessWidget {
  final Widget child;

  const _AttachmentPreview({required this.child});

  factory _AttachmentPreview.network(String url) {
    return _AttachmentPreview(child: Image.network(url, fit: BoxFit.cover));
  }

  factory _AttachmentPreview.memory(Uint8List bytes) {
    return _AttachmentPreview(child: Image.memory(bytes, fit: BoxFit.cover));
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(borderRadius: BorderRadius.circular(12), child: child);
  }
}
