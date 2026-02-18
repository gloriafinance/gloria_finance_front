import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/features/erp/devotional/models/devotional_models.dart';
import 'package:gloria_finance/features/erp/devotional/services/devotional_service.dart';
import 'package:gloria_finance/features/erp/devotional/widgets/devotional_status_badge.dart';

class DevotionalReviewScreen extends StatefulWidget {
  final String devotionalId;

  const DevotionalReviewScreen({super.key, required this.devotionalId});

  @override
  State<DevotionalReviewScreen> createState() => _DevotionalReviewScreenState();
}

class _DevotionalReviewScreenState extends State<DevotionalReviewScreen> {
  final DevotionalService _service = DevotionalService();

  bool _loading = true;
  bool _saving = false;

  DevotionalDetailModel? _detail;

  String _title = '';
  String _devotionalBody = '';
  String _pushTitle = '';
  String _pushBody = '';
  String _scripturesRaw = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final detail = await _service.getDevotional(widget.devotionalId);

      final content = detail.content;
      _title = content?.title ?? '';
      _devotionalBody = content?.devotional ?? '';
      _pushTitle = content?.pushTitle ?? '';
      _pushBody = content?.pushBody ?? '';
      _scripturesRaw =
          content?.scriptures
              .map((e) => '${e.reference} | ${e.quote}')
              .join('\n') ??
          '';

      if (!mounted) return;
      setState(() => _detail = detail);
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _saveEdits() async {
    final l10n = context.l10n;
    if (_title.trim().isEmpty ||
        _devotionalBody.trim().isEmpty ||
        _pushTitle.trim().isEmpty ||
        _pushBody.trim().isEmpty) {
      Toast.showMessage(
        l10n.devotional_review_fields_required,
        ToastType.warning,
      );
      return;
    }

    final scriptures = _parseScriptures(_scripturesRaw);
    if (scriptures.isEmpty) {
      Toast.showMessage(
        l10n.devotional_review_scripture_required,
        ToastType.warning,
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final detail = await _service.editDevotional(
        devotionalId: widget.devotionalId,
        content: DevotionalContentModel(
          title: _title,
          devotional: _devotionalBody,
          pushTitle: _pushTitle,
          pushBody: _pushBody,
          scriptures: scriptures,
        ),
      );
      if (!mounted) return;
      setState(() => _detail = detail);
      Toast.showMessage(l10n.devotional_review_updated, ToastType.success);
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _regenerate() async {
    final l10n = context.l10n;
    await _runLoader(
      message: l10n.devotional_loader_generating,
      subtitle: l10n.devotional_loader_subtitle,
      action: () => _service.regenerate(widget.devotionalId),
    );

    await _load();
  }

  Future<void> _approveAndSend() async {
    final l10n = context.l10n;
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(l10n.devotional_review_confirm_title),
            content: Text(l10n.devotional_review_confirm_message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.common_cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.devotional_review_confirm_yes),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    await _runLoader(
      message: l10n.devotional_review_loader_approving,
      subtitle: l10n.devotional_review_loader_approving_subtitle,
      action: () => _service.approve(widget.devotionalId),
    );

    if (mounted) {
      context.pop(true);
    }
  }

  Future<void> _retrySend() async {
    final l10n = context.l10n;
    await _service.retrySend(widget.devotionalId);
    if (!mounted) return;
    Toast.showMessage(l10n.devotional_review_retry_done, ToastType.success);
    await _load();
  }

  Future<void> _runLoader({
    required String message,
    required String subtitle,
    required Future<void> Function() action,
  }) async {
    final l10n = context.l10n;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: SizedBox(
            width: 360,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                const CircularProgressIndicator(color: AppColors.purple),
                const SizedBox(height: 18),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );

    try {
      await action();
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        Toast.showMessage(l10n.devotional_content_updated, ToastType.success);
      }
    } catch (_) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      rethrow;
    }
  }

  List<DevotionalScriptureModel> _parseScriptures(String raw) {
    final lines =
        raw
            .split('\n')
            .map((line) => line.trim())
            .where((line) => line.isNotEmpty)
            .toList();

    final result = <DevotionalScriptureModel>[];

    for (final line in lines) {
      final parts = line.contains('|') ? line.split('|') : line.split('-');
      if (parts.length < 2) continue;

      final reference = parts.first.trim();
      final quote = parts.sublist(1).join('|').trim();

      if (reference.isEmpty || quote.isEmpty) continue;

      result.add(DevotionalScriptureModel(reference: reference, quote: quote));
    }

    return result;
  }

  String _dayLabel(String day) {
    switch (day) {
      case 'MONDAY':
        return context.l10n.translate('schedule_day_monday');
      case 'TUESDAY':
        return context.l10n.translate('schedule_day_tuesday');
      case 'WEDNESDAY':
        return context.l10n.translate('schedule_day_wednesday');
      case 'THURSDAY':
        return context.l10n.translate('schedule_day_thursday');
      case 'FRIDAY':
        return context.l10n.translate('schedule_day_friday');
      case 'SATURDAY':
        return context.l10n.translate('schedule_day_saturday');
      case 'SUNDAY':
        return context.l10n.translate('schedule_day_sunday');
      default:
        return day;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'pending':
        return context.l10n.devotional_status_pending;
      case 'generating':
        return context.l10n.devotional_status_generating;
      case 'in_review':
        return context.l10n.devotional_status_in_review;
      case 'approved':
        return context.l10n.devotional_status_approved;
      case 'sending':
        return context.l10n.devotional_status_sending;
      case 'sent':
        return context.l10n.devotional_status_sent;
      case 'failed':
      case 'error':
        return context.l10n.devotional_status_failed;
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _detail == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final detail = _detail!;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.devotional_review_title,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 22,
                    color: AppColors.black,
                  ),
                ),
              ),
              DevotionalStatusBadge(
                status: detail.item.status,
                label: _statusLabel(detail.item.status),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.devotional_review_header_line(
              _dayLabel(detail.item.dayOfWeek),
              detail.item.scheduleDate,
              detail.item.audience,
            ),
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              color: AppColors.grey,
            ),
          ),
          Input(
            label: context.l10n.devotional_review_label_title,
            initialValue: _title,
            onChanged: (value) => _title = value,
          ),
          Input(
            label: context.l10n.devotional_review_label_content,
            maxLines: 10,
            initialValue: _devotionalBody,
            onChanged: (value) => _devotionalBody = value,
          ),
          if (isMobile(context))
            Column(
              children: [
                Input(
                  label: context.l10n.devotional_review_label_push_title,
                  initialValue: _pushTitle,
                  onChanged: (value) => _pushTitle = value,
                ),
                Input(
                  label: context.l10n.devotional_review_label_push_body,
                  initialValue: _pushBody,
                  onChanged: (value) => _pushBody = value,
                ),
              ],
            ),
          if (!isMobile(context))
            Row(
              children: [
                Expanded(
                  child: Input(
                    label: context.l10n.devotional_review_label_push_title,
                    initialValue: _pushTitle,
                    onChanged: (value) => _pushTitle = value,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Input(
                    label: context.l10n.devotional_review_label_push_body,
                    initialValue: _pushBody,
                    onChanged: (value) => _pushBody = value,
                  ),
                ),
              ],
            ),
          Input(
            label: context.l10n.devotional_review_label_scriptures,
            maxLines: 6,
            initialValue: _scripturesRaw,
            onChanged: (value) => _scripturesRaw = value,
          ),
          const SizedBox(height: 14),
          if (isMobile(context))
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ButtonActionTable(
                      color: AppColors.blue,
                      text:
                          _saving
                              ? context.l10n.devotional_saving
                              : context.l10n.devotional_review_save_changes,
                      icon: Icons.save,
                      onPressed: _saving ? () {} : _saveEdits,
                    ),
                    ButtonActionTable(
                      color: AppColors.mustard,
                      text: context.l10n.devotional_regenerate,
                      icon: Icons.auto_awesome,
                      onPressed: _regenerate,
                    ),
                    if (detail.item.status == 'failed')
                      ButtonActionTable(
                        color: AppColors.purple,
                        text: context.l10n.devotional_retry_send,
                        icon: Icons.refresh,
                        onPressed: _retrySend,
                      ),
                    ButtonActionTable(
                      color: AppColors.grey,
                      text: context.l10n.devotional_review_cancel,
                      icon: Icons.arrow_back,
                      onPressed: () => context.pop(false),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: context.l10n.devotional_review_approve_send,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  leading: const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 16,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  onPressed: _approveAndSend,
                ),
              ],
            ),
          if (!isMobile(context))
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ButtonActionTable(
                        color: AppColors.blue,
                        text:
                            _saving
                                ? context.l10n.devotional_saving
                                : context.l10n.devotional_review_save_changes,
                        icon: Icons.save,
                        onPressed: _saving ? () {} : _saveEdits,
                      ),
                      ButtonActionTable(
                        color: AppColors.mustard,
                        text: context.l10n.devotional_regenerate,
                        icon: Icons.auto_awesome,
                        onPressed: _regenerate,
                      ),
                      if (detail.item.status == 'failed')
                        ButtonActionTable(
                          color: AppColors.purple,
                          text: context.l10n.devotional_retry_send,
                          icon: Icons.refresh,
                          onPressed: _retrySend,
                        ),
                      ButtonActionTable(
                        color: AppColors.grey,
                        text: context.l10n.devotional_review_cancel,
                        icon: Icons.arrow_back,
                        onPressed: () => context.pop(false),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 240,
                  child: CustomButton(
                    text: context.l10n.devotional_review_approve_send,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    leading: const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 16,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    onPressed: _approveAndSend,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
