import 'dart:math' as math;
import 'dart:typed_data';

import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/patrimony/models/patrimony_asset_model.dart';
import 'package:church_finance_bk/settings/members/store/member_all_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PatrimonyAssetDetailView extends StatelessWidget {
  final PatrimonyAssetModel asset;

  const PatrimonyAssetDetailView({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Consumer<MemberAllStore>(
      builder: (context, memberStore, _) {
        final responsibleName = _resolveResponsible(memberStore);

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _summaryCard(context, responsibleName),
              const SizedBox(height: 24),
              _attachmentsSection(context),
              const SizedBox(height: 24),
              _historySection(),
            ],
          ),
        );
      },
    );
  }

  String _resolveResponsible(MemberAllStore memberStore) {
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

  Widget _summaryCard(BuildContext context, String responsibleName) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 720;
        final columnWidth = isCompact
            ? constraints.maxWidth
            : math.min(360.0, (constraints.maxWidth - 16) / 2).toDouble();

        final entries = [
          _InfoEntry(label: 'Categoria', value: asset.categoryLabel),
          _InfoEntry(
            label: 'Data de aquisição',
            value: asset.acquisitionDateLabel.isEmpty
                ? '-'
                : asset.acquisitionDateLabel,
          ),
          _InfoEntry(
            label: 'Localização',
            value:
                asset.location?.isNotEmpty == true ? asset.location! : '-',
          ),
          _InfoEntry(label: 'Responsável', value: responsibleName),
          _InfoEntry(
            label: 'Documentos pendentes',
            valueWidget: _buildPendingBadge(),
          ),
          _InfoEntry(
            label: 'Observações',
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
              color: _statusColor(),
            ),
          );
        }

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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          asset.name,
                          style: const TextStyle(
                            fontFamily: AppFonts.fontTitle,
                            fontSize: 20,
                          ),
                        ),
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
                                  ? 'Atualizado em ${_formatDate(asset.updatedAt!)}'
                                  : 'Atualizado em -',
                              style: const TextStyle(color: AppColors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (!isCompact) _editButton(context),
                ],
              ),
              if (isCompact) ...[
                const SizedBox(height: 16),
                _editButton(context, fullWidth: true),
              ],
              if (metadataBadges.isNotEmpty) ...[
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: metadataBadges,
                ),
              ],
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: entries
                    .map(
                      (entry) {
                        final width = (entry.fullWidth || isCompact)
                            ? constraints.maxWidth
                            : columnWidth;
                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: width,
                            maxWidth: width,
                          ),
                          child: _InfoTile(entry: entry),
                        );
                      },
                    )
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPendingBadge() {
    final pending = asset.documentsPending;
    final color = pending ? AppColors.mustard : AppColors.green;
    final icon = pending
        ? Icons.warning_amber_outlined
        : Icons.check_circle_outline;

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
            pending ? 'Sim' : 'Não',
            style: TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _editButton(BuildContext context, {bool fullWidth = false}) {
    final button = OutlinedButton.icon(
      onPressed: () => GoRouter.of(context)
          .go('/patrimony/assets/${asset.assetId}/edit', extra: asset),
      icon: const Icon(Icons.edit_outlined, color: AppColors.purple),
      label: const Text(
        'Editar',
        style: TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          color: AppColors.purple,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        side: const BorderSide(color: AppColors.purple),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  Widget _attachmentsSection(BuildContext context) {
    if (asset.attachments.isEmpty) {
      return const Text(
        'Nenhum anexo disponível.',
        style: TextStyle(fontFamily: AppFonts.fontSubTitle),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 640;
        final cardWidth = isCompact
            ? constraints.maxWidth
            : math.min(320.0, (constraints.maxWidth - 16) / 2).toDouble();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Anexos',
              style: TextStyle(
                fontFamily: AppFonts.fontTitle,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: asset.attachments.map((attachment) {
                final isImage =
                    attachment.mimetype.toLowerCase().startsWith('image/');
                final isPdf = attachment.mimetype.toLowerCase().contains('pdf');
                return _AttachmentCard(
                  width: cardWidth,
                  name: attachment.name,
                  sizeLabel: attachment.formattedSize,
                  uploadedLabel: attachment.uploadedAtLabel,
                  preview: isImage
                      ? _AttachmentPreview.network(attachment.url)
                      : const Icon(
                          Icons.insert_drive_file,
                          color: AppColors.purple,
                          size: 42,
                        ),
                  actionLabel: isPdf ? 'Ver PDF' : 'Abrir',
                  onView: () => _openUrl(attachment.url),
                  onPreviewTap: isImage
                      ? () => _showImageDialog(
                            context,
                            Image.network(attachment.url, fit: BoxFit.contain),
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

  Widget _historySection() {
    if (asset.history.isEmpty) {
      return const Text(
        'Sem histórico de alterações.',
        style: TextStyle(fontFamily: AppFonts.fontSubTitle),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Histórico de movimentações',
          style: TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 12),
        ...asset.history.map((entry) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.greyMiddle),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entry.action} • ${entry.performedAtLabel}',
                  style: const TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (entry.notes?.isNotEmpty == true)
                  Text('Notas: ${entry.notes}',
                      style: const TextStyle(fontFamily: AppFonts.fontSubTitle)),
                if (entry.changes.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Alterações registradas:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  ...entry.formattedChanges.map(
                    (change) => Text('- $change'),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year • $hour:$minute';
  }

  Color _statusColor() {
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

  static Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static Future<void> _showImageDialog(BuildContext context, Widget image) async {
    await showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(24),
        child: SizedBox(
          width: 480,
          child: InteractiveViewer(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: image,
            ),
          ),
        ),
      ),
    );
  }
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
  }) : assert(value != null || valueWidget != null);
}

class _InfoTile extends StatelessWidget {
  final _InfoEntry entry;

  const _InfoTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyMiddle),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry.label,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              color: AppColors.purple,
            ),
          ),
          const SizedBox(height: 8),
          entry.valueWidget ??
              SelectableText(
                entry.value!,
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
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.greyMiddle),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: onPreviewTap ?? onView,
              child: preview,
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(sizeLabel, style: const TextStyle(color: AppColors.grey)),
            if (uploadedLabel.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Enviado em $uploadedLabel',
                style: const TextStyle(color: AppColors.grey, fontSize: 12),
              ),
            ],
            const SizedBox(height: 12),
            CustomButton(
              text: actionLabel,
              backgroundColor: AppColors.blue,
              textColor: Colors.white,
              onPressed: onView,
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachmentPreview extends StatelessWidget {
  final Widget child;

  const _AttachmentPreview._(this.child);

  factory _AttachmentPreview.network(String url) {
    return _AttachmentPreview._(
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          url,
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const SizedBox(
            height: 160,
            child: Center(
              child: Icon(Icons.broken_image, color: AppColors.grey, size: 48),
            ),
          ),
        ),
      ),
    );
  }

  factory _AttachmentPreview.memory(Uint8List bytes) {
    return _AttachmentPreview._(
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(
          bytes,
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const SizedBox(
            height: 160,
            child: Center(
              child: Icon(Icons.broken_image, color: AppColors.grey, size: 48),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return child;
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
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            color: color,
          ),
        ),
      ],
    ),
  );
}
