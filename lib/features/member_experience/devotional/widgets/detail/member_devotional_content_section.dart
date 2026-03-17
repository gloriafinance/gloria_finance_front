import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/member_experience/devotional/models/member_devotional_models.dart';
import 'package:gloria_finance/features/member_experience/devotional/widgets/detail/member_devotional_detail_sections.dart';

class MemberDevotionalContentSection extends StatelessWidget {
  final String content;

  const MemberDevotionalContentSection({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return MemberDevotionalEditorialSection(
      title: context.l10n.member_devotional_detail_content_title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildParagraphs(content),
      ),
    );
  }

  List<Widget> _buildParagraphs(String value) {
    final paragraphs =
        value
            .split(RegExp(r'\n\s*\n'))
            .map((paragraph) => paragraph.trim())
            .where((paragraph) => paragraph.isNotEmpty)
            .toList();

    if (paragraphs.isEmpty) {
      return const [
        Text(
          '',
          style: TextStyle(
            fontFamily: AppFonts.fontText,
            fontSize: 16,
            height: 1.92,
            color: AppColors.black,
          ),
        ),
      ];
    }

    return paragraphs
        .map(
          (paragraph) => Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Text(
              paragraph,
              style: const TextStyle(
                fontFamily: AppFonts.fontText,
                fontSize: 16,
                height: 1.92,
                color: AppColors.black,
              ),
            ),
          ),
        )
        .toList();
  }
}

class MemberDevotionalScripturesSection extends StatelessWidget {
  final List<MemberDevotionalScriptureModel> scriptures;

  const MemberDevotionalScripturesSection({
    super.key,
    required this.scriptures,
  });

  @override
  Widget build(BuildContext context) {
    if (scriptures.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MemberDevotionalEditorialSectionHeader(
          title: context.l10n.member_devotional_detail_scriptures_title,
        ),
        const SizedBox(height: 10),
        ...scriptures.map(
          (scripture) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _MemberDevotionalScriptureCard(scripture: scripture),
          ),
        ),
      ],
    );
  }
}

class _MemberDevotionalScriptureCard extends StatelessWidget {
  final MemberDevotionalScriptureModel scripture;

  const _MemberDevotionalScriptureCard({required this.scripture});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF8F1FF), Color(0xFFFFFCF7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.purple.withAlpha(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.purple.withAlpha(18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  size: 18,
                  color: AppColors.purple,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  scripture.reference,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.purple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            scripture.quote,
            style: const TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 14,
              height: 1.65,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
