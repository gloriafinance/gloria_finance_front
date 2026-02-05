import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/schedule/models/schedule_models.dart';
import 'package:gloria_finance/features/erp/schedule/service/schedule_service.dart';
import 'package:gloria_finance/features/member_experience/widgets/member_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MemberScheduleDetailScreen extends StatefulWidget {
  final WeeklyOccurrence occurrence;

  const MemberScheduleDetailScreen({super.key, required this.occurrence});

  @override
  State<MemberScheduleDetailScreen> createState() =>
      _MemberScheduleDetailScreenState();
}

class _MemberScheduleDetailScreenState
    extends State<MemberScheduleDetailScreen> {
  late final Future<ScheduleItemConfig?> _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = _loadDetail();
  }

  Future<ScheduleItemConfig?> _loadDetail() async {
    final id = widget.occurrence.scheduleItemId;
    if (id.trim().isEmpty) {
      return null;
    }
    return ScheduleService().getScheduleItemById(id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        MemberHeaderWidget(
          title: l10n.schedule_list_title,
          onBack: () => context.pop(),
        ),
        Expanded(
          child: FutureBuilder<ScheduleItemConfig?>(
            future: _detailFuture,
            builder: (context, snapshot) {
              final item = snapshot.data;
              final loading =
                  snapshot.connectionState == ConnectionState.waiting;

              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                children: [
                  _HeroEventCard(occurrence: widget.occurrence, item: item),
                  const SizedBox(height: 14),
                  _SectionCard(
                    title: l10n.member_schedule_detail_information_title,
                    child: _TypeRow(type: widget.occurrence.type),
                  ),
                  const SizedBox(height: 14),
                  _SectionCard(
                    title: l10n.member_schedule_detail_details_title,
                    trailing:
                        item?.observations == null &&
                                item?.description == null &&
                                item?.preacher == null
                            ? Text(
                              l10n.member_schedule_detail_optional_label,
                              style: TextStyle(
                                fontFamily: AppFonts.fontText,
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            )
                            : null,
                    child:
                        loading
                            ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Center(
                                child: SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            )
                            : _DetailsBody(
                              occurrence: widget.occurrence,
                              item: item,
                            ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _HeroEventCard extends StatelessWidget {
  final WeeklyOccurrence occurrence;
  final ScheduleItemConfig? item;

  const _HeroEventCard({required this.occurrence, required this.item});

  @override
  Widget build(BuildContext context) {
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final parsedDate = DateTime.tryParse(occurrence.date);
    final dateLabel =
        parsedDate == null
            ? occurrence.date
            : DateFormat('EEEE, d MMMM', localeTag).format(parsedDate);

    final address = item?.location.address ?? occurrence.location.address ?? '';

    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            occurrence.title,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 14),
          _InfoRow(icon: Icons.calendar_today_outlined, text: dateLabel),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.access_time,
            text: '${occurrence.startTime} até ${occurrence.endTime}',
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.location_on_outlined,
            text:
                address.trim().isEmpty
                    ? occurrence.location.name
                    : '${occurrence.location.name}\n$address',
          ),
          const SizedBox(height: 12),
          _VisibilityChip(visibility: occurrence.visibility),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;

  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withAlpha(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(icon, color: AppColors.purple, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 14,
              height: 1.25,
              color: Colors.grey.shade800,
            ),
          ),
        ),
      ],
    );
  }
}

class _VisibilityChip extends StatelessWidget {
  final ScheduleVisibility visibility;

  const _VisibilityChip({required this.visibility});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final label = l10n.translate(visibility.friendlyName);

    final Color background =
        visibility == ScheduleVisibility.public
            ? const Color(0xFF2E7D32)
            : Colors.grey.shade700;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.group, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const _SectionCard({required this.title, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _TypeRow extends StatelessWidget {
  final ScheduleItemType type;

  const _TypeRow({required this.type});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final typeLabel = l10n.translate(type.friendlyName);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF2B705),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            children: [
              const Icon(Icons.home_outlined, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                l10n.schedule_detail_type,
                style: const TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            typeLabel,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailsBody extends StatelessWidget {
  final WeeklyOccurrence occurrence;
  final ScheduleItemConfig? item;

  const _DetailsBody({required this.occurrence, required this.item});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final description =
        (item?.description ?? '').trim().isEmpty
            ? null
            : item!.description!.trim();

    final observations =
        (item?.observations ?? '').trim().isEmpty
            ? null
            : item!.observations!.trim();

    final director =
        (item?.director ?? '').trim().isEmpty ? null : item!.director.trim();
    final preacher =
        (item?.preacher ?? '').trim().isEmpty ? null : item!.preacher!.trim();

    final recurrenceText = _formatRecurrence(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (description != null) ...[
          Text(
            description,
            style: TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 14,
              height: 1.35,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 14),
        ],
        if (observations != null) ...[
          Text(
            observations,
            style: TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 14,
              height: 1.35,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 14),
        ],
        if (director != null || preacher != null) ...[
          Wrap(
            spacing: 18,
            runSpacing: 10,
            children: [
              if (director != null)
                _MiniInfo(
                  icon: Icons.person,
                  label: l10n.schedule_detail_director,
                  value: director,
                ),
              if (preacher != null)
                _MiniInfo(
                  icon: Icons.mic,
                  label: l10n.schedule_detail_preacher,
                  value: preacher,
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        if (recurrenceText != null)
          _MiniInfo(
            icon: Icons.calendar_month_outlined,
            label: l10n.schedule_form_section_recurrence,
            value: recurrenceText,
          ),
        if (recurrenceText == null)
          Text(
            l10n.member_schedule_detail_no_extra_info,
            style: TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
      ],
    );
  }

  String? _formatRecurrence(BuildContext context) {
    final item = this.item;
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final parsed = DateTime.tryParse(occurrence.date);

    final dayLabel =
        item != null
            ? context.l10n.translate(
              item.recurrencePattern.dayOfWeek.friendlyName,
            )
            : (parsed == null
                ? null
                : DateFormat('EEEE', localeTag).format(parsed));

    final timeLabel = item?.recurrencePattern.time ?? occurrence.startTime;

    if (dayLabel == null || dayLabel.trim().isEmpty) return null;

    final language = Localizations.localeOf(context).languageCode;
    if (language == 'pt') {
      return 'Semanalmente — $dayLabel às $timeLabel';
    }
    if (language == 'es') {
      return 'Semanalmente — $dayLabel a las $timeLabel';
    }
    return 'Weekly — $dayLabel at $timeLabel';
  }
}

class _MiniInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MiniInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.purple, size: 18),
        const SizedBox(width: 8),
        Text(
          '$label ',
          style: const TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        Flexible(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 13,
              color: Colors.grey.shade800,
            ),
          ),
        ),
      ],
    );
  }
}
