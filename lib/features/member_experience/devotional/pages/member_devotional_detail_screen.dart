import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/member_experience/devotional/models/member_devotional_models.dart';
import 'package:gloria_finance/features/member_experience/devotional/service/member_devotional_service.dart';
import 'package:gloria_finance/features/member_experience/widgets/member_header.dart';
import 'package:intl/intl.dart';

class MemberDevotionalDetailScreen extends StatefulWidget {
  final String devotionalId;

  const MemberDevotionalDetailScreen({super.key, required this.devotionalId});

  @override
  State<MemberDevotionalDetailScreen> createState() =>
      _MemberDevotionalDetailScreenState();
}

class _MemberDevotionalDetailScreenState
    extends State<MemberDevotionalDetailScreen> {
  final MemberDevotionalService _service = MemberDevotionalService();

  bool _isLoading = true;
  String? _errorMessage;
  MemberDevotionalDetailModel? _detail;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final detail = await _service.fetchDevotionalDetail(widget.devotionalId);
      if (!mounted) return;
      setState(() => _detail = detail);
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        children: [
          MemberHeaderWidget(
            title: context.l10n.member_home_devotional_moment_title,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _buildBody(context),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading && _detail == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 28),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null && _detail == null) {
      return Column(
        children: [
          Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.fontText,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: _load, child: Text(context.l10n.common_retry)),
        ],
      );
    }

    final detail = _detail;
    if (detail == null || !detail.hasContent) {
      return Text(
        context.l10n.member_devotional_detail_unavailable,
        style: TextStyle(
          fontFamily: AppFonts.fontText,
          color: Colors.grey.shade700,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeaderCard(detail: detail),
        const SizedBox(height: 14),
        Text(
          context.l10n.member_devotional_detail_content_title,
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black.withAlpha(12)),
          ),
          child: Text(
            detail.devotional,
            style: const TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 15,
              height: 1.6,
              color: AppColors.black,
            ),
          ),
        ),
        if (detail.scriptures.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(
            context.l10n.member_devotional_detail_scriptures_title,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          ...detail.scriptures.map(
            (scripture) => _ScriptureCard(scripture: scripture),
          ),
        ],
      ],
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final MemberDevotionalDetailModel detail;

  const _HeaderCard({required this.detail});

  @override
  Widget build(BuildContext context) {
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final dateLabel =
        detail.scheduledAt == null
            ? detail.scheduleDate
            : DateFormat(
              'EEEE, dd MMMM • HH:mm',
              localeTag,
            ).format(detail.scheduledAt!.toLocal());

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withAlpha(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(14),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            detail.title.isEmpty
                ? context.l10n.devotional_item_no_title
                : detail.title,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            dateLabel,
            style: TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScriptureCard extends StatelessWidget {
  final MemberDevotionalScriptureModel scripture;

  const _ScriptureCard({required this.scripture});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.purple.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            scripture.reference,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontWeight: FontWeight.w700,
              color: AppColors.purple,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            scripture.quote,
            style: const TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 14,
              height: 1.45,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
