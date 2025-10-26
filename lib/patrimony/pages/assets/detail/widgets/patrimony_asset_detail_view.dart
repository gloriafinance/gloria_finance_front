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
    final entries = [
      _InfoEntry('Código', asset.code.isEmpty ? '-' : asset.code),
      _InfoEntry('Categoria', asset.categoryLabel),
      _InfoEntry('Valor', asset.valueLabel),
      _InfoEntry('Data de aquisição',
          asset.acquisitionDateLabel.isEmpty ? '-' : asset.acquisitionDateLabel),
      _InfoEntry('Congregação', asset.churchId.isEmpty ? '-' : asset.churchId),
      _InfoEntry('Localização', asset.location?.isNotEmpty == true ? asset.location! : '-'),
      _InfoEntry('Responsável', responsibleName),
      _InfoEntry('Status', asset.statusLabel.isEmpty ? '-' : asset.statusLabel),
      _InfoEntry('Documentos pendentes', asset.documentsPending ? 'Sim' : 'Não'),
      _InfoEntry('Observações', asset.notes?.isNotEmpty == true ? asset.notes! : '-'),
    ];

    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 800;
    final itemWidth = isCompact ? double.infinity : (width / 2) - 80;

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
                    const SizedBox(height: 4),
                    Text(
                      'Última atualização: '
                      '${asset.updatedAt != null ? _formatDate(asset.updatedAt!) : '-'}',
                      style: const TextStyle(color: AppColors.grey),
                    ),
                  ],
                ),
              ),
              CustomButton(
                text: 'Editar',
                backgroundColor: AppColors.purple,
                textColor: Colors.white,
                icon: Icons.edit_outlined,
                onPressed: () => GoRouter.of(context)
                    .go('/patrimony/assets/${asset.assetId}/edit', extra: asset),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: entries
                .map(
                  (entry) => SizedBox(
                    width: itemWidth,
                    child: _InfoTile(entry: entry),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _attachmentsSection(BuildContext context) {
    if (asset.attachments.isEmpty) {
      return const Text(
        'Nenhum anexo disponível.',
        style: TextStyle(fontFamily: AppFonts.fontSubTitle),
      );
    }

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
          spacing: 12,
          runSpacing: 12,
          children: asset.attachments.map((attachment) {
            final isImage = attachment.mimetype.toLowerCase().startsWith('image/');
            final isPdf = attachment.mimetype.toLowerCase().contains('pdf');
            return _AttachmentCard(
              name: attachment.name,
              sizeLabel: attachment.formattedSize,
              uploadedLabel: attachment.uploadedAtLabel,
              preview: isImage
                  ? _AttachmentPreview.network(attachment.url)
                  : const Icon(Icons.insert_drive_file,
                      color: AppColors.purple, size: 42),
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
  final String value;

  _InfoEntry(this.label, this.value);
}

class _InfoTile extends StatelessWidget {
  final _InfoEntry entry;

  const _InfoTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          entry.label,
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            color: AppColors.purple,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          entry.value,
          style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
        ),
      ],
    );
  }
}

class _AttachmentCard extends StatelessWidget {
  final String name;
  final String sizeLabel;
  final String uploadedLabel;
  final Widget preview;
  final String actionLabel;
  final VoidCallback onView;
  final VoidCallback? onPreviewTap;

  const _AttachmentCard({
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
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyMiddle),
        color: Colors.white,
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
