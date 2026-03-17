import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/member_experience/devotional/models/member_devotional_models.dart';
import 'package:gloria_finance/features/member_experience/devotional/store/member_devotional_detail_store.dart';
import 'package:gloria_finance/features/member_experience/devotional/widgets/detail/member_devotional_community_section.dart';

class MemberDevotionalShareSheet extends StatelessWidget {
  final VoidCallback onWhatsApp;
  final VoidCallback onFacebook;
  final VoidCallback onInstagram;
  final VoidCallback onCopyText;
  final VoidCallback onSystemShare;

  const MemberDevotionalShareSheet({
    super.key,
    required this.onWhatsApp,
    required this.onFacebook,
    required this.onInstagram,
    required this.onCopyText,
    required this.onSystemShare,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: MemberDevotionalBottomSheetShell(
        maxHeightFactor: 0.7,
        scrollable: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.member_devotional_detail_share_title,
              style: const TextStyle(
                fontFamily: AppFonts.fontTitle,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              context.l10n.member_devotional_detail_share_subtitle,
              style: TextStyle(
                fontFamily: AppFonts.fontText,
                fontSize: 14,
                height: 1.55,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 18),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.45,
              children: [
                _ShareActionButton(
                  icon: Icons.message_rounded,
                  label: context.l10n.member_devotional_detail_share_whatsapp,
                  accent: const Color(0xFF25D366),
                  onTap: onWhatsApp,
                ),
                _ShareActionButton(
                  icon: Icons.facebook_rounded,
                  label: context.l10n.member_devotional_detail_share_facebook,
                  accent: const Color(0xFF1877F2),
                  onTap: onFacebook,
                ),
                _ShareActionButton(
                  icon: Icons.camera_alt_rounded,
                  label: context.l10n.member_devotional_detail_share_instagram,
                  accent: const Color(0xFFE4405F),
                  onTap: onInstagram,
                ),
                _ShareActionButton(
                  icon: Icons.link_rounded,
                  label: context.l10n.member_devotional_detail_share_copy_text,
                  accent: AppColors.purple,
                  onTap: onCopyText,
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: onSystemShare,
                icon: const Icon(Icons.share_rounded),
                label: Text(context.l10n.member_devotional_detail_share_system),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MemberDevotionalCommentsSheet extends StatelessWidget {
  final MemberDevotionalDetailStore store;
  final TextEditingController commentController;
  final Future<void> Function() onSubmit;
  final ValueChanged<MemberDevotionalCommentModel> onEditComment;
  final VoidCallback onCancelEditing;

  const MemberDevotionalCommentsSheet({
    super.key,
    required this.store,
    required this.commentController,
    required this.onSubmit,
    required this.onEditComment,
    required this.onCancelEditing,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: SafeArea(
        top: false,
        child: MemberDevotionalBottomSheetShell(
          maxHeightFactor: 0.88,
          scrollable: true,
          child: AnimatedBuilder(
            animation: store,
            builder: (context, _) {
              final state = store.state;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.member_devotional_detail_comments_title,
                    style: const TextStyle(
                      fontFamily: AppFonts.fontTitle,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    context.l10n.member_devotional_detail_comments_subtitle,
                    style: TextStyle(
                      fontFamily: AppFonts.fontText,
                      fontSize: 14,
                      height: 1.55,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 18),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 320),
                    child:
                        state.community.comments.isEmpty
                            ? Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                child: Text(
                                  context
                                      .l10n
                                      .member_devotional_detail_comments_empty,
                                  style: TextStyle(
                                    fontFamily: AppFonts.fontText,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            )
                            : ListView.separated(
                              shrinkWrap: true,
                              itemCount: state.community.comments.length,
                              separatorBuilder:
                                  (_, __) => const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final comment = state.community.comments[index];
                                return MemberDevotionalCommentCard(
                                  comment: comment,
                                  onEdit:
                                      store.canEditComment(comment)
                                          ? () => onEditComment(comment)
                                          : null,
                                );
                              },
                            ),
                  ),
                  const SizedBox(height: 16),
                  if (state.isEditingComment)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6EFFC),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              context
                                  .l10n
                                  .member_devotional_detail_comments_editing,
                              style: const TextStyle(
                                fontFamily: AppFonts.fontSubTitle,
                                fontWeight: FontWeight.w700,
                                color: AppColors.purple,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: onCancelEditing,
                            child: Text(
                              context
                                  .l10n
                                  .member_devotional_detail_comments_cancel_edit,
                            ),
                          ),
                        ],
                      ),
                    ),
                  TextField(
                    controller: commentController,
                    maxLines: 3,
                    minLines: 2,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText:
                          context
                              .l10n
                              .member_devotional_detail_comments_input_hint,
                      filled: true,
                      fillColor: const Color(0xFFF7F2FB),
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: state.isSubmittingComment ? null : onSubmit,
                      child: Text(
                        state.isSubmittingComment
                            ? context.l10n.common_processing
                            : state.isEditingComment
                            ? context
                                .l10n
                                .member_devotional_detail_comments_update
                            : context
                                .l10n
                                .member_devotional_detail_comments_send,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class MemberDevotionalBottomSheetShell extends StatelessWidget {
  final Widget child;
  final bool scrollable;
  final double maxHeightFactor;

  const MemberDevotionalBottomSheetShell({
    super.key,
    required this.child,
    this.scrollable = false,
    this.maxHeightFactor = 0.9,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(12),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(height: 18),
        child,
      ],
    );

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * maxHeightFactor,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: scrollable ? SingleChildScrollView(child: content) : content,
      ),
    );
  }
}

class _ShareActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accent;
  final VoidCallback onTap;

  const _ShareActionButton({
    required this.icon,
    required this.label,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFAF7FD),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accent.withAlpha(18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
