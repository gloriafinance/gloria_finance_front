import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/member_experience/devotional/models/member_devotional_models.dart';
import 'package:intl/intl.dart';

class MemberDevotionalDetailTopBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback? onShare;

  const MemberDevotionalDetailTopBar({
    super.key,
    required this.onBack,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CircleActionButton(icon: Icons.arrow_back_rounded, onTap: onBack),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.member_devotional_detail_breadcrumb,
                style: TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                context.l10n.member_home_devotional_moment_title,
                style: const TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
        _CircleActionButton(icon: Icons.ios_share_rounded, onTap: onShare),
      ],
    );
  }
}

class MemberDevotionalHeroCard extends StatelessWidget {
  final MemberDevotionalDetailModel detail;
  final String highlight;

  const MemberDevotionalHeroCard({
    super.key,
    required this.detail,
    required this.highlight,
  });

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
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5A2F90), Color(0xFF8453BA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withAlpha(50),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -18,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withAlpha(24),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -20,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFDDA7).withAlpha(36),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.member_devotional_detail_hero_kicker,
                style: const TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(28),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  dateLabel,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                detail.title.isEmpty
                    ? context.l10n.devotional_item_no_title
                    : detail.title,
                style: const TextStyle(
                  fontFamily: AppFonts.fontTitle,
                  fontSize: 28,
                  height: 1.1,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(18),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withAlpha(24)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.member_devotional_detail_quote_label,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontSubTitle,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '“$highlight”',
                      style: const TextStyle(
                        fontFamily: AppFonts.fontText,
                        fontSize: 18,
                        height: 1.55,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MemberDevotionalSectionCard extends StatelessWidget {
  final Widget child;
  final MemberDevotionalSectionTone tone;

  const MemberDevotionalSectionCard({
    super.key,
    required this.child,
    this.tone = MemberDevotionalSectionTone.plain,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = switch (tone) {
      MemberDevotionalSectionTone.plain => Colors.white,
      MemberDevotionalSectionTone.tinted => const Color(0xFFFCF9FF),
      MemberDevotionalSectionTone.warm => const Color(0xFFFFFCF8),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.black.withAlpha(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class MemberDevotionalEditorialSection extends StatelessWidget {
  final String title;
  final Widget child;

  const MemberDevotionalEditorialSection({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MemberDevotionalEditorialSectionHeader(title: title),
        const SizedBox(height: 16),
        child,
      ],
    );
  }
}

class MemberDevotionalEditorialSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const MemberDevotionalEditorialSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: AppFonts.fontTitle,
            fontSize: 20,
            height: 1.18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 13.5,
              height: 1.55,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ],
    );
  }
}

class MemberDevotionalEditorialEyebrow extends StatelessWidget {
  final String label;

  const MemberDevotionalEditorialEyebrow({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: AppFonts.fontSubTitle,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Colors.grey.shade600,
      ),
    );
  }
}

class MemberDevotionalCountPill extends StatelessWidget {
  final String label;

  const MemberDevotionalCountPill({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(210),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black.withAlpha(8)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }
}

class MemberDevotionalSharePromptCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onTap;

  const MemberDevotionalSharePromptCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black.withAlpha(8))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppFonts.fontTitle,
              fontSize: 17,
              height: 1.2,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 13.5,
              height: 1.5,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.purple,
                side: BorderSide(color: AppColors.purple.withAlpha(30)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: onTap,
              icon: const Icon(Icons.ios_share_rounded, size: 18),
              label: Text(actionLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CircleActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.black.withAlpha(10)),
          ),
          child: Icon(icon, color: AppColors.purple),
        ),
      ),
    );
  }
}

enum MemberDevotionalSectionTone { plain, tinted, warm }
