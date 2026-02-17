import 'package:flutter/material.dart';
import 'package:gloria_finance/core/layout/modal_page_layout.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';

import '../../models/church_model.dart';

class ChurchProfileDoctrinalBasesCard extends StatelessWidget {
  final List<ChurchDoctrinalBaseModel> doctrinalBases;
  final ValueChanged<List<ChurchDoctrinalBaseModel>> onChanged;

  const ChurchProfileDoctrinalBasesCard({
    super.key,
    required this.doctrinalBases,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoBanner(context),
        const SizedBox(height: 20),
        if (doctrinalBases.isEmpty) _emptyState(context),
        if (doctrinalBases.isNotEmpty)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: doctrinalBases.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final item = doctrinalBases[index];
              return _DoctrinalBaseViewCard(
                index: index,
                item: item,
                onEdit: () => _openEditorModal(context, index: index),
                onDelete: () => _removeAt(index),
              );
            },
          ),
      ],
    );
  }

  Widget _buildInfoBanner(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.blue.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.blue.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.info, color: AppColors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settings_church_profile_doctrinal_important,
                  style: const TextStyle(
                    color: AppColors.blue,
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.settings_church_profile_doctrinal_banner_text,
                  style: const TextStyle(
                    color: AppColors.blue,
                    fontFamily: AppFonts.fontText,
                    fontSize: 16,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyMiddle),
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
      ),
      child: Text(
        l10n.settings_church_profile_doctrinal_empty,
        style: const TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          color: AppColors.grey,
          fontSize: 15,
        ),
      ),
    );
  }

  Future<void> _openEditorModal(BuildContext context, {int? index}) async {
    final initial = index != null ? doctrinalBases[index] : null;
    final result = await showDoctrinalBaseEditorModal(
      context,
      initial: initial,
    );

    if (result == null) {
      return;
    }

    final updated = List<ChurchDoctrinalBaseModel>.from(doctrinalBases);
    if (index == null) {
      updated.add(result);
    } else {
      updated[index] = result;
    }

    onChanged(updated);
  }

  void _removeAt(int index) {
    final updated = List<ChurchDoctrinalBaseModel>.from(doctrinalBases)
      ..removeAt(index);
    onChanged(updated);
  }
}

Future<ChurchDoctrinalBaseModel?> showDoctrinalBaseEditorModal(
  BuildContext context, {
  ChurchDoctrinalBaseModel? initial,
}) {
  final l10n = AppLocalizations.of(context)!;
  return ModalPage(
    title:
        initial == null
            ? l10n.settings_church_profile_doctrinal_add_title
            : l10n.settings_church_profile_doctrinal_edit_title,
    width: 720,
    body: _DoctrinalBaseFormModal(initial: initial),
  ).show<ChurchDoctrinalBaseModel>(context);
}

class _DoctrinalBaseViewCard extends StatelessWidget {
  final int index;
  final ChurchDoctrinalBaseModel item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _DoctrinalBaseViewCard({
    required this.index,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scriptureTags = _parseScriptureTags(item.scripture);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.greyMiddle),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settings_church_profile_doctrinal_title_label,
                  style: const TextStyle(
                    color: Color(0xFF374151),
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontFamily: AppFonts.fontSubTitle,
                    fontSize: 17,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.settings_church_profile_doctrinal_scripture_label,
                  style: const TextStyle(
                    color: Color(0xFF374151),
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                if (scriptureTags.isEmpty)
                  Text(
                    l10n.settings_church_profile_doctrinal_scripture_empty,
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontFamily: AppFonts.fontText,
                    ),
                  ),
                if (scriptureTags.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        scriptureTags
                            .map(
                              (tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.blue.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: AppColors.blue.withValues(
                                      alpha: 0.2,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  tag,
                                  style: const TextStyle(
                                    color: Color(0xFF1D4ED8),
                                    fontFamily: AppFonts.fontSubTitle,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
        border: Border(
          bottom: BorderSide(
            color: AppColors.greyMiddle.withValues(alpha: 0.8),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.purple.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: AppColors.purple,
                fontFamily: AppFonts.fontTitle,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ButtonActionTable(
            color: AppColors.blue,
            text: l10n.settings_church_profile_doctrinal_edit_tooltip,
            onPressed: onEdit,
            icon: Icons.edit_outlined,
          ),
          ButtonActionTable(
            color: Colors.red,
            text: l10n.settings_church_profile_doctrinal_delete_tooltip,
            onPressed: onDelete,
            icon: Icons.delete_outline_rounded,
          ),
        ],
      ),
    );
  }
}

class _DoctrinalBaseFormModal extends StatefulWidget {
  final ChurchDoctrinalBaseModel? initial;

  const _DoctrinalBaseFormModal({this.initial});

  @override
  State<_DoctrinalBaseFormModal> createState() =>
      _DoctrinalBaseFormModalState();
}

class _DoctrinalBaseFormModalState extends State<_DoctrinalBaseFormModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  final TextEditingController _scriptureInputController =
      TextEditingController();
  late List<String> _scriptureTags;
  bool _showTagError = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initial?.title ?? '');
    _scriptureTags = _parseScriptureTags(widget.initial?.scripture ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _scriptureInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.settings_church_profile_doctrinal_form_title,
              style: const TextStyle(
                fontFamily: AppFonts.fontTitle,
                color: AppColors.purple,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n
                      .settings_church_profile_doctrinal_form_title_error;
                }
                return null;
              },
              decoration: InputDecoration(
                hintText:
                    l10n.settings_church_profile_doctrinal_form_title_hint,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.purple),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.settings_church_profile_doctrinal_form_scripture,
              style: const TextStyle(
                fontFamily: AppFonts.fontTitle,
                color: AppColors.purple,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.settings_church_profile_doctrinal_form_scripture_hint,
              style: const TextStyle(
                fontFamily: AppFonts.fontText,
                color: Color(0xFF6B7280),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _scriptureInputController,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _addTagFromInput(),
              decoration: InputDecoration(
                hintText: 'Ex: 2Tm 3:16',
                prefixIcon: const Icon(
                  Icons.menu_book_outlined,
                  color: Color(0xFF9CA3AF),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.purple),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  _scriptureTags
                      .map(
                        (tag) => InputChip(
                          label: Text(tag),
                          onDeleted: () => _removeTag(tag),
                          deleteIconColor: AppColors.purple,
                          backgroundColor: AppColors.blue.withValues(
                            alpha: 0.12,
                          ),
                          side: BorderSide(
                            color: AppColors.blue.withValues(alpha: 0.22),
                          ),
                        ),
                      )
                      .toList(),
            ),
            if (_showTagError) ...[
              const SizedBox(height: 8),
              Text(
                l10n.settings_church_profile_doctrinal_form_scripture_error,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ButtonActionTable(
                  color: AppColors.grey,
                  text: l10n.settings_church_profile_cancel,
                  icon: Icons.close,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ButtonActionTable(
                  color: AppColors.purple,
                  text: l10n.settings_church_profile_save,
                  icon: Icons.check,
                  onPressed: _submit,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addTagFromInput() {
    final normalized = _normalizeTag(_scriptureInputController.text);
    if (normalized.isEmpty) {
      return;
    }

    if (_scriptureTags.any(
      (tag) => tag.toLowerCase() == normalized.toLowerCase(),
    )) {
      _scriptureInputController.clear();
      return;
    }

    setState(() {
      _scriptureTags = [..._scriptureTags, normalized];
      _scriptureInputController.clear();
      _showTagError = false;
    });
  }

  void _removeTag(String tag) {
    setState(() {
      _scriptureTags = _scriptureTags.where((item) => item != tag).toList();
    });
  }

  void _submit() {
    final isValidForm = _formKey.currentState?.validate() == true;
    if (!isValidForm) {
      return;
    }

    _addTagFromInput();
    if (_scriptureTags.isEmpty) {
      setState(() => _showTagError = true);
      return;
    }

    final result = ChurchDoctrinalBaseModel(
      title: _titleController.text.trim(),
      scripture: _scriptureTags.join('; '),
    );

    Navigator.of(context).pop(result);
  }
}

List<String> _parseScriptureTags(String value) {
  return value
      .replaceAll('\n', ';')
      .split(RegExp(r'[;,]'))
      .map(_normalizeTag)
      .where((item) => item.isNotEmpty)
      .toList();
}

String _normalizeTag(String value) {
  return value.trim().replaceAll(RegExp(r'^[,;]+|[,;]+$'), '').trim();
}
