import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/patrimony/models/patrimony_asset_model.dart';
import 'package:church_finance_bk/patrimony/pages/assets/detail/store/patrimony_asset_detail_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PatrimonyAssetDetailView extends StatelessWidget {
  final String assetId;

  const PatrimonyAssetDetailView({super.key, required this.assetId});

  @override
  Widget build(BuildContext context) {
    return Consumer<PatrimonyAssetDetailStore>(
      builder: (context, store, _) {
        final state = store.state;

        if (state.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: AppColors.mustard, size: 48),
                const SizedBox(height: 12),
                const Text('Não conseguimos carregar o bem selecionado.'),
                const SizedBox(height: 12),
                CustomButton(
                  text: 'Tentar novamente',
                  backgroundColor: AppColors.purple,
                  textColor: Colors.white,
                  onPressed: () => store.loadAsset(assetId),
                ),
              ],
            ),
          );
        }

        final asset = state.asset;
        if (asset == null) {
          return const Center(
            child: Text('Bem não encontrado ou removido.'),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _summaryCard(context, asset),
            const SizedBox(height: 24),
            _attachmentsSection(asset),
            const SizedBox(height: 24),
            _historySection(asset),
          ],
        );
      },
    );
  }

  Widget _summaryCard(BuildContext context, PatrimonyAssetModel asset) {
    final entries = [
      _InfoEntry('Código', asset.code.isEmpty ? '-' : asset.code),
      _InfoEntry('Categoria', asset.categoryLabel),
      _InfoEntry('Valor', asset.valueLabel),
      _InfoEntry('Data de aquisição', asset.acquisitionDateLabel.isEmpty ? '-' : asset.acquisitionDateLabel),
      _InfoEntry('Congregação', asset.churchId),
      _InfoEntry('Localização', asset.location?.isNotEmpty == true ? asset.location! : '-'),
      _InfoEntry('Responsável', asset.responsibleId ?? '-'),
      _InfoEntry('Status', asset.statusLabel),
      _InfoEntry('Documentos pendentes', asset.documentsPending ? 'Sim' : 'Não'),
      _InfoEntry('Observações', asset.notes?.isNotEmpty == true ? asset.notes! : '-'),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                asset.name,
                style: const TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 20,
                ),
              ),
              CustomButton(
                text: 'Editar',
                backgroundColor: AppColors.purple,
                textColor: Colors.white,
                icon: Icons.edit_outlined,
                onPressed: () => GoRouter.of(context)
                    .go('/patrimony/assets/${asset.assetId}/edit'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: entries
                .map((entry) => SizedBox(
                      width: MediaQuery.of(context).size.width < 800
                          ? double.infinity
                          : (MediaQuery.of(context).size.width / 2) - 80,
                      child: _InfoTile(entry: entry),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _attachmentsSection(PatrimonyAssetModel asset) {
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
        ...asset.attachments.map((attachment) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.greyMiddle),
            ),
            child: Row(
              children: [
                const Icon(Icons.insert_drive_file, color: AppColors.purple),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attachment.name,
                        style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
                      ),
                      Text(
                        attachment.formattedSize,
                        style: const TextStyle(color: AppColors.grey),
                      ),
                    ],
                  ),
                ),
                CustomButton(
                  text: 'Abrir',
                  backgroundColor: AppColors.blue,
                  textColor: Colors.white,
                  onPressed: () => _openUrl(attachment.url),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _historySection(PatrimonyAssetModel asset) {
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

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Não foi possível abrir o anexo');
    }
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
