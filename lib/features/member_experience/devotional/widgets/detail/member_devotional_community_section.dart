import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/member_experience/devotional/models/member_devotional_models.dart';
import 'package:gloria_finance/features/member_experience/devotional/widgets/detail/member_devotional_detail_sections.dart';
import 'package:intl/intl.dart';

class MemberDevotionalCommunitySection extends StatelessWidget {
  final MemberDevotionalCommunityModel community;
  final bool Function(MemberDevotionalCommentModel comment) canEditComment;
  final ValueChanged<MemberDevotionalCommentModel> onEditComment;
  final VoidCallback onComment;
  final VoidCallback onViewComments;

  const MemberDevotionalCommunitySection({
    super.key,
    required this.community,
    required this.canEditComment,
    required this.onEditComment,
    required this.onComment,
    required this.onViewComments,
  });

  @override
  Widget build(BuildContext context) {
    return MemberDevotionalSectionCard(
      tone: MemberDevotionalSectionTone.warm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MemberDevotionalEditorialSectionHeader(
            title: context.l10n.member_devotional_detail_comments_title,
            subtitle: context.l10n.member_devotional_detail_comments_subtitle,
          ),
          const SizedBox(height: 12),
          _CommunityPresence(
            commentCount: community.totalComments,
            avatars:
                community.comments
                    .take(3)
                    .map((comment) => comment.authorName)
                    .toList(),
          ),
          const SizedBox(height: 16),
          if (community.comments.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(196),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(
                context.l10n.member_devotional_detail_comments_empty,
                style: TextStyle(
                  fontFamily: AppFonts.fontText,
                  color: Colors.grey.shade700,
                  height: 1.45,
                ),
              ),
            )
          else
            _CommunityPreview(
              eyebrow: context.l10n.member_devotional_detail_comment_highlight,
              comment: community.comments.first,
              canEdit: canEditComment(community.comments.first),
              onEdit:
                  canEditComment(community.comments.first)
                      ? () => onEditComment(community.comments.first)
                      : null,
            ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: onComment,
                  icon: const Icon(Icons.edit_note_rounded),
                  label: Text(
                    context.l10n.member_devotional_detail_comments_write,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.purple,
                    side: BorderSide(color: AppColors.purple.withAlpha(36)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: onViewComments,
                  icon: const Icon(Icons.forum_outlined),
                  label: Text(
                    context.l10n.member_devotional_detail_comments_view_all,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MemberDevotionalCommentCard extends StatelessWidget {
  final MemberDevotionalCommentModel comment;
  final VoidCallback? onEdit;

  const MemberDevotionalCommentCard({
    super.key,
    required this.comment,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final timeLabel =
        comment.createdAt == null
            ? '--:--'
            : DateFormat(
              'HH:mm',
              localeTag,
            ).format(comment.createdAt!.toLocal());

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(212),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black.withAlpha(6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.purple.withAlpha(18),
                child: Text(
                  comment.authorName.isEmpty
                      ? '?'
                      : comment.authorName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontWeight: FontWeight.w700,
                    color: AppColors.purple,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.authorName,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontSubTitle,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      timeLabel,
                      style: TextStyle(
                        fontFamily: AppFonts.fontText,
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (comment.isEdited)
                      Text(
                        context.l10n.member_devotional_detail_comments_edited,
                        style: TextStyle(
                          fontFamily: AppFonts.fontText,
                          fontSize: 11.5,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              ),
              if (onEdit != null)
                PopupMenuButton<String>(
                  tooltip: context.l10n.member_devotional_detail_comments_edit,
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit!();
                    }
                  },
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text(
                            context.l10n.member_devotional_detail_comments_edit,
                          ),
                        ),
                      ],
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            comment.message,
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

class _CommunityPreview extends StatelessWidget {
  final String eyebrow;
  final MemberDevotionalCommentModel comment;
  final bool canEdit;
  final VoidCallback? onEdit;

  const _CommunityPreview({
    required this.eyebrow,
    required this.comment,
    required this.canEdit,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MemberDevotionalEditorialEyebrow(label: eyebrow),
        const SizedBox(height: 8),
        MemberDevotionalCommentCard(
          comment: comment,
          onEdit: canEdit ? onEdit : null,
        ),
      ],
    );
  }
}

class _CommunityPresence extends StatelessWidget {
  final int commentCount;
  final List<String> avatars;

  const _CommunityPresence({required this.commentCount, required this.avatars});

  @override
  Widget build(BuildContext context) {
    final hasComments = commentCount > 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(150),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _AvatarStack(names: avatars),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              hasComments
                  ? context.l10n.member_devotional_detail_comments_presence(
                    commentCount,
                  )
                  : context
                      .l10n
                      .member_devotional_detail_comments_presence_empty,
              style: TextStyle(
                fontFamily: AppFonts.fontText,
                fontSize: 13,
                height: 1.45,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarStack extends StatelessWidget {
  final List<String> names;

  const _AvatarStack({required this.names});

  @override
  Widget build(BuildContext context) {
    final initials =
        names
            .where((name) => name.trim().isNotEmpty)
            .take(3)
            .map((name) => name.trim().substring(0, 1).toUpperCase())
            .toList();

    if (initials.isEmpty) {
      initials.add('?');
    }

    return SizedBox(
      width: 24.0 + ((initials.length - 1) * 18),
      height: 28,
      child: Stack(
        children: [
          for (var index = 0; index < initials.length; index++)
            Positioned(
              left: index * 18,
              child: CircleAvatar(
                radius: 14,
                backgroundColor:
                    index.isEven
                        ? AppColors.purple.withAlpha(18)
                        : const Color(0xFFFFE9D1),
                child: Text(
                  initials[index],
                  style: TextStyle(
                    fontFamily: AppFonts.fontSubTitle,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color:
                        index.isEven
                            ? AppColors.purple
                            : const Color(0xFF9B5F17),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
