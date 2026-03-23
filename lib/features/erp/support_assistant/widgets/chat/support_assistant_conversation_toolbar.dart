import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/support_assistant/models/support_conversation_model.dart';

class SupportAssistantConversationToolbar extends StatefulWidget {
  const SupportAssistantConversationToolbar({
    super.key,
    required this.isCompact,
    required this.fillHeight,
    required this.isLoading,
    required this.selectedConversationId,
    required this.recentConversations,
    required this.onStartNewConversation,
    required this.onOpenConversation,
    required this.onDeleteConversation,
  });

  final bool isCompact;
  final bool fillHeight;
  final bool isLoading;
  final String selectedConversationId;
  final List<SupportConversationSummaryModel> recentConversations;
  final VoidCallback onStartNewConversation;
  final ValueChanged<String> onOpenConversation;
  final ValueChanged<String> onDeleteConversation;

  @override
  State<SupportAssistantConversationToolbar> createState() =>
      _SupportAssistantConversationToolbarState();
}

class _SupportAssistantConversationToolbarState
    extends State<SupportAssistantConversationToolbar> {
  String? _expandedGroupKey;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final groups = _groupRecentConversations(widget.recentConversations);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE7E9F0)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed:
                  widget.isLoading ? null : widget.onStartNewConversation,
              icon: const Icon(Icons.add_comment_outlined),
              label: Text(l10n.support_assistant_new_conversation),
            ),
          ),
          if (groups.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              l10n.support_assistant_recent_conversations,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),
            widget.fillHeight
                ? Expanded(child: _buildConversationList(groups))
                : ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: widget.isCompact ? 220 : 360,
                  ),
                  child: _buildConversationList(groups),
                ),
          ],
        ],
      ),
    );
  }

  Widget _buildConversationList(List<_GroupedConversation> groups) {
    return Scrollbar(
      thumbVisibility: groups.length > 3,
      child: ListView.separated(
        primary: false,
        itemCount: groups.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final group = groups[index];
          final latest = group.conversations.first;
          final isExpanded = _expandedGroupKey == group.key;
          final hasSelectedConversation = group.conversations.any(
            (item) => item.conversationId == widget.selectedConversationId,
          );

          return _ConversationGroupTile(
            key: ValueKey('support-conversation-item-${latest.conversationId}'),
            group: group,
            isExpanded: isExpanded,
            isLoading: widget.isLoading,
            hasSelectedConversation: hasSelectedConversation,
            selectedConversationId: widget.selectedConversationId,
            onToggleExpanded:
                group.conversations.length > 1
                    ? () {
                      setState(() {
                        _expandedGroupKey = isExpanded ? null : group.key;
                      });
                    }
                    : null,
            onOpenConversation: widget.onOpenConversation,
            onDeleteConversation: widget.onDeleteConversation,
          );
        },
      ),
    );
  }

  List<_GroupedConversation> _groupRecentConversations(
    List<SupportConversationSummaryModel> conversations,
  ) {
    final grouped = <String, List<SupportConversationSummaryModel>>{};

    for (final conversation in conversations) {
      final key = conversation.title.trim().toLowerCase();
      grouped.putIfAbsent(key, () => []).add(conversation);
    }

    final items =
        grouped.entries.map((entry) {
          final list = [...entry.value];
          list.sort((a, b) {
            final aDate = DateTime.tryParse(a.updatedAt);
            final bDate = DateTime.tryParse(b.updatedAt);
            if (aDate == null && bDate == null) return 0;
            if (aDate == null) return 1;
            if (bDate == null) return -1;
            return bDate.compareTo(aDate);
          });

          return _GroupedConversation(
            key: entry.key,
            title: list.first.title,
            conversations: list,
          );
        }).toList(growable: false);

    items.sort((a, b) {
      final aDate = DateTime.tryParse(a.conversations.first.updatedAt);
      final bDate = DateTime.tryParse(b.conversations.first.updatedAt);
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return bDate.compareTo(aDate);
    });

    return items.take(widget.isCompact ? 5 : 12).toList(growable: false);
  }
}

class _GroupedConversation {
  const _GroupedConversation({
    required this.key,
    required this.title,
    required this.conversations,
  });

  final String key;
  final String title;
  final List<SupportConversationSummaryModel> conversations;
}

class _ConversationGroupTile extends StatelessWidget {
  const _ConversationGroupTile({
    super.key,
    required this.group,
    required this.isExpanded,
    required this.isLoading,
    required this.hasSelectedConversation,
    required this.selectedConversationId,
    required this.onOpenConversation,
    required this.onDeleteConversation,
    this.onToggleExpanded,
  });

  final _GroupedConversation group;
  final bool isExpanded;
  final bool isLoading;
  final bool hasSelectedConversation;
  final String selectedConversationId;
  final VoidCallback? onToggleExpanded;
  final ValueChanged<String> onOpenConversation;
  final ValueChanged<String> onDeleteConversation;

  @override
  Widget build(BuildContext context) {
    final latest = group.conversations.first;
    final baseBorder = const Color(0xFFE3E5EC);
    final selectedBorder = const Color(0xFFD2C0F8);
    final background =
        hasSelectedConversation
            ? const Color(0xFFF2EAFF)
            : Colors.white.withValues(alpha: 0.9);
    final titleColor =
        hasSelectedConversation ? const Color(0xFF4F2B8C) : Colors.black87;
    final metaColor = Colors.black45;

    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: hasSelectedConversation ? selectedBorder : baseBorder,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: isLoading ? null : () => onOpenConversation(latest.conversationId),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    hasSelectedConversation
                        ? Icons.check_circle_rounded
                        : Icons.chat_bubble_outline_rounded,
                    size: 18,
                    color: titleColor,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: AppFonts.fontSubTitle,
                            color: titleColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              _formatUpdatedAt(latest.updatedAt),
                              style: TextStyle(fontSize: 11, color: metaColor),
                            ),
                            if (group.conversations.length > 1) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F2F7),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  '${group.conversations.length}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (group.conversations.length > 1)
                    IconButton(
                      key: ValueKey('support-conversation-expand-${group.key}'),
                      onPressed: isLoading ? null : onToggleExpanded,
                      icon: Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  IconButton(
                    key: ValueKey(
                      'support-conversation-delete-${latest.conversationId}',
                    ),
                    onPressed:
                        isLoading
                            ? null
                            : () => onDeleteConversation(latest.conversationId),
                    icon: const Icon(Icons.delete_outline_rounded),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE7E9F0)),
              ),
              child: Column(
                children:
                    group.conversations.map((conversation) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _ConversationHistoryRow(
                          conversation: conversation,
                          isLoading: isLoading,
                          isSelected:
                              conversation.conversationId ==
                              selectedConversationId,
                          onOpenConversation: onOpenConversation,
                          onDeleteConversation: onDeleteConversation,
                        ),
                      );
                    }).toList(growable: false),
              ),
            ),
        ],
      ),
    );
  }

  String _formatUpdatedAt(String value) {
    final date = DateTime.tryParse(value);
    if (date == null) return '';

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month $hour:$minute';
  }
}

class _ConversationHistoryRow extends StatelessWidget {
  const _ConversationHistoryRow({
    required this.conversation,
    required this.isLoading,
    required this.isSelected,
    required this.onOpenConversation,
    required this.onDeleteConversation,
  });

  final SupportConversationSummaryModel conversation;
  final bool isLoading;
  final bool isSelected;
  final ValueChanged<String> onOpenConversation;
  final ValueChanged<String> onDeleteConversation;

  @override
  Widget build(BuildContext context) {
    final background =
        isSelected ? const Color(0xFFEDE4FF) : Colors.white;
    final border =
        isSelected ? const Color(0xFFD2C0F8) : const Color(0xFFE5E7EB);

    return Container(
      key: ValueKey('support-conversation-row-${conversation.conversationId}'),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          const Icon(Icons.history_rounded, size: 14, color: Colors.black45),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _formatUpdatedAt(conversation.updatedAt),
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
          TextButton(
            onPressed:
                isLoading ? null : () => onOpenConversation(conversation.conversationId),
            child: Text(context.l10n.common_view),
          ),
          IconButton(
            key: ValueKey('support-conversation-delete-${conversation.conversationId}'),
            onPressed:
                isLoading ? null : () => onDeleteConversation(conversation.conversationId),
            icon: const Icon(Icons.delete_outline_rounded, size: 18),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  String _formatUpdatedAt(String value) {
    final date = DateTime.tryParse(value);
    if (date == null) return '';

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month $hour:$minute';
  }
}
