import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/member_experience/devotional/models/member_devotional_models.dart';
import 'package:gloria_finance/features/member_experience/devotional/store/member_devotional_detail_store.dart';
import 'package:gloria_finance/features/member_experience/devotional/utils/member_devotional_experience.dart';
import 'package:gloria_finance/features/member_experience/devotional/widgets/detail/member_devotional_bottom_sheets.dart';
import 'package:gloria_finance/features/member_experience/devotional/widgets/detail/member_devotional_community_section.dart';
import 'package:gloria_finance/features/member_experience/devotional/widgets/detail/member_devotional_content_section.dart';
import 'package:gloria_finance/features/member_experience/devotional/widgets/detail/member_devotional_detail_sections.dart';
import 'package:gloria_finance/features/member_experience/devotional/widgets/detail/member_devotional_reactions_section.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberDevotionalDetailScreen extends StatefulWidget {
  final String devotionalId;

  const MemberDevotionalDetailScreen({super.key, required this.devotionalId});

  @override
  State<MemberDevotionalDetailScreen> createState() =>
      _MemberDevotionalDetailScreenState();
}

class _MemberDevotionalDetailScreenState
    extends State<MemberDevotionalDetailScreen> {
  late final MemberDevotionalDetailStore _store;
  late final TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _store = MemberDevotionalDetailStore(devotionalId: widget.devotionalId)
      ..load();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _store.dispose();
    super.dispose();
  }

  String _shareMessage() {
    final detail = _store.state.detail;
    if (detail == null) return '';

    final content = devotionalShareBody(detail.devotional);

    return context.l10n.member_devotional_detail_share_message(
      detail.title.isEmpty
          ? context.l10n.devotional_item_no_title
          : detail.title,
      content,
    );
  }

  Future<void> _shareSystem() async {
    await SharePlus.instance.share(ShareParams(text: _shareMessage()));
  }

  Future<void> _shareToWhatsApp() async {
    final uri = Uri.parse(
      'https://wa.me/?text=${Uri.encodeComponent(_shareMessage())}',
    );
    await _launchExternal(uri);
  }

  Future<void> _shareToFacebook() async {
    await SharePlus.instance.share(ShareParams(text: _shareMessage()));
  }

  Future<void> _shareToInstagram() async {
    await SharePlus.instance.share(ShareParams(text: _shareMessage()));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.l10n.member_devotional_detail_share_instagram_hint,
        ),
      ),
    );
  }

  Future<void> _copyShareText() async {
    await Clipboard.setData(ClipboardData(text: _shareMessage()));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.member_devotional_detail_share_text_copied),
      ),
    );
  }

  Future<void> _launchExternal(Uri uri) async {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _toggleReaction(String reactionId) async {
    try {
      await _store.toggleReaction(reactionId);
    } catch (error) {
      _showTransientError(error);
    }
  }

  Future<void> _submitComment() async {
    try {
      final submitted = await _store.submitComment(_commentController.text);
      if (!submitted) return;
      _commentController.clear();
      if (!mounted) return;
      FocusScope.of(context).unfocus();
    } catch (error) {
      _showTransientError(error);
    }
  }

  void _startEditingComment(MemberDevotionalCommentModel comment) {
    _store.beginEditingComment(comment);
    _commentController
      ..text = comment.message
      ..selection = TextSelection.fromPosition(
        TextPosition(offset: comment.message.length),
      );
  }

  void _cancelEditingComment() {
    _store.cancelEditingComment();
    _commentController.clear();
  }

  void _openEditingComment(MemberDevotionalCommentModel comment) {
    _startEditingComment(comment);
    _showCommentsSheet();
  }

  void _showTransientError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(error.toString())));
  }

  Future<void> _showShareSheet() async {
    if (_store.state.detail == null) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return MemberDevotionalShareSheet(
          onWhatsApp: _shareToWhatsApp,
          onFacebook: _shareToFacebook,
          onInstagram: _shareToInstagram,
          onCopyText: _copyShareText,
          onSystemShare: _shareSystem,
        );
      },
    );
  }

  Future<void> _showCommentsSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return MemberDevotionalCommentsSheet(
          store: _store,
          commentController: _commentController,
          onSubmit: _submitComment,
          onEditComment: _startEditingComment,
          onCancelEditing: _cancelEditingComment,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FB),
      body: Stack(
        children: [
          Positioned(
            top: -120,
            right: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.purple.withAlpha(28),
              ),
            ),
          ),
          Positioned(
            left: -40,
            top: 220,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFE6C8).withAlpha(80),
              ),
            ),
          ),
          SafeArea(
            child: AnimatedBuilder(
              animation: _store,
              builder: (context, _) {
                final state = _store.state;
                return RefreshIndicator(
                  onRefresh: _store.load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
                    children: [
                      MemberDevotionalDetailTopBar(
                        onBack:
                            () =>
                                context.canPop()
                                    ? context.pop()
                                    : context.go('/'),
                        onShare: state.detail == null ? null : _showShareSheet,
                      ),
                      const SizedBox(height: 18),
                      _buildBody(),
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

  Widget _buildBody() {
    final state = _store.state;

    if (state.isLoading && state.detail == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 28),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.errorMessage != null && state.detail == null) {
      return _FeedbackState(
        message: state.errorMessage!,
        actionLabel: context.l10n.common_retry,
        onAction: _store.load,
      );
    }

    final detail = state.detail;
    if (detail == null || !detail.hasContent) {
      return _FeedbackState(
        message: context.l10n.member_devotional_detail_unavailable,
      );
    }

    final community = state.community;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MemberDevotionalHeroCard(
          detail: detail,
          highlight: devotionalHighlightText(detail.devotional),
        ),
        const SizedBox(height: 22),
        MemberDevotionalContentSection(content: detail.devotional),
        if (detail.scriptures.isNotEmpty) ...[
          const SizedBox(height: 24),
          MemberDevotionalScripturesSection(scriptures: detail.scriptures),
        ],
        const SizedBox(height: 24),
        MemberDevotionalReactionsSection(
          isUpdating: state.isUpdatingReaction,
          totalReactions: community.totalReactions,
          selectedReaction: community.viewerReactionType,
          reactionCounts: community.reactionCounts,
          onToggleReaction: _toggleReaction,
        ),
        const SizedBox(height: 24),
        MemberDevotionalCommunitySection(
          community: community,
          canEditComment: _store.canEditComment,
          onEditComment: _openEditingComment,
          onComment: _showCommentsSheet,
          onViewComments: _showCommentsSheet,
        ),
        const SizedBox(height: 14),
        MemberDevotionalSharePromptCard(
          title: context.l10n.member_devotional_detail_share_title,
          subtitle: context.l10n.member_devotional_detail_share_subtitle,
          actionLabel: context.l10n.member_devotional_detail_share_action,
          onTap: _showShareSheet,
        ),
      ],
    );
  }
}

class _FeedbackState extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _FeedbackState({
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withAlpha(12)),
      ),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade700),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 12),
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}
