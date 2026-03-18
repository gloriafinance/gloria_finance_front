import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/devotional/models/devotional_community_models.dart';

enum DevotionalCommunityInsightsPresentation { sheet, dialog }

class DevotionalCommunityInsightsSheet extends StatefulWidget {
  final String devotionalTitle;
  final Future<DevotionalCommunityInsightsModel> Function() loadInsights;
  final DevotionalCommunityInsightsPresentation presentation;

  const DevotionalCommunityInsightsSheet({
    super.key,
    required this.devotionalTitle,
    required this.loadInsights,
    this.presentation = DevotionalCommunityInsightsPresentation.sheet,
  });

  @override
  State<DevotionalCommunityInsightsSheet> createState() =>
      _DevotionalCommunityInsightsSheetState();
}

class _DevotionalCommunityInsightsSheetState
    extends State<DevotionalCommunityInsightsSheet> {
  late Future<DevotionalCommunityInsightsModel> _future;

  bool get _isDialog =>
      widget.presentation == DevotionalCommunityInsightsPresentation.dialog;

  @override
  void initState() {
    super.initState();
    _future = widget.loadInsights();
  }

  void _retry() {
    setState(() {
      _future = widget.loadInsights();
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = _InsightsSurface(
      devotionalTitle: widget.devotionalTitle,
      isDialog: _isDialog,
      future: _future,
      onRetry: _retry,
    );

    if (_isDialog) {
      return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: content,
      );
    }

    return SafeArea(top: false, child: content);
  }
}

class _InsightsSurface extends StatelessWidget {
  final String devotionalTitle;
  final bool isDialog;
  final Future<DevotionalCommunityInsightsModel> future;
  final VoidCallback onRetry;

  const _InsightsSurface({
    required this.devotionalTitle,
    required this.isDialog,
    required this.future,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: isDialog ? 760 : double.infinity,
        maxHeight:
            MediaQuery.of(context).size.height * (isDialog ? 0.78 : 0.82),
      ),
      padding: EdgeInsets.fromLTRB(
        isDialog ? 28 : 20,
        14,
        isDialog ? 28 : 20,
        24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isDialog ? 28 : 28),
        boxShadow:
            isDialog
                ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(18),
                    blurRadius: 30,
                    offset: const Offset(0, 18),
                  ),
                ]
                : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isDialog) ...[
            Center(
              child: Container(
                width: 46,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(14),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 18),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.devotional_engagement_title,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontTitle,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      devotionalTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontSubTitle,
                        fontWeight: FontWeight.w700,
                        color: AppColors.purple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.devotional_engagement_subtitle,
                      style: TextStyle(
                        fontFamily: AppFonts.fontText,
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              if (isDialog)
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                ),
            ],
          ),
          const SizedBox(height: 22),
          Flexible(
            child: FutureBuilder<DevotionalCommunityInsightsModel>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return _CommunityInsightsErrorState(onRetry: onRetry);
                }

                final insights = snapshot.data;
                if (insights == null || !insights.hasEngagement) {
                  return _CommunityInsightsEmptyState(
                    message: context.l10n.devotional_engagement_empty,
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _InsightMetricCard(
                              icon: Icons.favorite_border_rounded,
                              label:
                                  context.l10n.devotional_engagement_reactions,
                              value: insights.totalReactions.toString(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _InsightMetricCard(
                              icon: Icons.forum_outlined,
                              label:
                                  context.l10n.devotional_engagement_comments,
                              value: insights.totalComments.toString(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      isDialog
                          ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _InsightSectionCard(
                                  title:
                                      context
                                          .l10n
                                          .devotional_engagement_reactions,
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children:
                                        insights.reactionCounts.entries
                                            .where((entry) => entry.value > 0)
                                            .map(
                                              (entry) => _ReactionChip(
                                                label: _reactionLabel(
                                                  context,
                                                  entry.key,
                                                ),
                                                count: entry.value,
                                              ),
                                            )
                                            .toList(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _InsightSectionCard(
                                  title:
                                      context
                                          .l10n
                                          .devotional_engagement_comments,
                                  child:
                                      insights.comments.isEmpty
                                          ? Text(
                                            context
                                                .l10n
                                                .devotional_engagement_comments_empty,
                                            style: TextStyle(
                                              fontFamily: AppFonts.fontText,
                                              height: 1.5,
                                              color: Colors.grey.shade700,
                                            ),
                                          )
                                          : Column(
                                            children:
                                                insights.comments
                                                    .take(3)
                                                    .map(
                                                      (comment) => Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              bottom: 10,
                                                            ),
                                                        child:
                                                            _CommentPreviewCard(
                                                              comment: comment,
                                                            ),
                                                      ),
                                                    )
                                                    .toList(),
                                          ),
                                ),
                              ),
                            ],
                          )
                          : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _InsightSectionCard(
                                title:
                                    context
                                        .l10n
                                        .devotional_engagement_reactions,
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children:
                                      insights.reactionCounts.entries
                                          .where((entry) => entry.value > 0)
                                          .map(
                                            (entry) => _ReactionChip(
                                              label: _reactionLabel(
                                                context,
                                                entry.key,
                                              ),
                                              count: entry.value,
                                            ),
                                          )
                                          .toList(),
                                ),
                              ),
                              const SizedBox(height: 14),
                              _InsightSectionCard(
                                title:
                                    context.l10n.devotional_engagement_comments,
                                child:
                                    insights.comments.isEmpty
                                        ? Text(
                                          context
                                              .l10n
                                              .devotional_engagement_comments_empty,
                                          style: TextStyle(
                                            fontFamily: AppFonts.fontText,
                                            height: 1.5,
                                            color: Colors.grey.shade700,
                                          ),
                                        )
                                        : Column(
                                          children:
                                              insights.comments
                                                  .take(3)
                                                  .map(
                                                    (comment) => Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            bottom: 10,
                                                          ),
                                                      child:
                                                          _CommentPreviewCard(
                                                            comment: comment,
                                                          ),
                                                    ),
                                                  )
                                                  .toList(),
                                        ),
                              ),
                            ],
                          ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _reactionLabel(BuildContext context, String reactionId) {
    switch (reactionId) {
      case 'edified':
        return context.l10n.member_devotional_reaction_edified;
      case 'amen':
        return context.l10n.member_devotional_reaction_amen;
      case 'challenged':
        return context.l10n.member_devotional_reaction_challenged;
      case 'peace':
        return context.l10n.member_devotional_reaction_peace;
      case 'reflect':
        return context.l10n.member_devotional_reaction_reflect;
      default:
        return reactionId;
    }
  }
}

class _InsightMetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InsightMetricCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5FB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.purple.withAlpha(10)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.purple.withAlpha(18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.purple),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: AppFonts.fontTitle,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppFonts.fontText,
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightSectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _InsightSectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFAFE),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black.withAlpha(6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _ReactionChip extends StatelessWidget {
  final String label;
  final int count;

  const _ReactionChip({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: AppColors.purple.withAlpha(12),
        border: Border.all(color: AppColors.purple.withAlpha(22)),
      ),
      child: Text(
        '$label · $count',
        style: const TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          fontSize: 12,
          color: AppColors.purple,
        ),
      ),
    );
  }
}

class _CommentPreviewCard extends StatelessWidget {
  final DevotionalCommunityCommentModel comment;

  const _CommentPreviewCard({required this.comment});

  @override
  Widget build(BuildContext context) {
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final timeLabel =
        comment.createdAt == null
            ? '--:--'
            : DateFormat(
              'dd/MM HH:mm',
              localeTag,
            ).format(comment.createdAt!.toLocal());

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withAlpha(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.purple.withAlpha(16),
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
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comment.message,
            style: const TextStyle(
              fontFamily: AppFonts.fontText,
              fontSize: 14,
              height: 1.55,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _CommunityInsightsEmptyState extends StatelessWidget {
  final String message;

  const _CommunityInsightsEmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppFonts.fontText,
            height: 1.5,
            color: Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}

class _CommunityInsightsErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _CommunityInsightsErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.app_error_unexpected_retry,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.fontText,
              height: 1.5,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onRetry,
            child: Text(context.l10n.common_retry),
          ),
        ],
      ),
    );
  }
}
