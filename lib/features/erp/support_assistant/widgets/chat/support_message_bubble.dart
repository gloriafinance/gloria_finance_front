import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/features/erp/support_assistant/models/support_chat_attachment_model.dart';
import 'package:gloria_finance/features/erp/support_assistant/models/support_chat_message_model.dart';
import 'package:gloria_finance/features/erp/support_assistant/widgets/chat/support_response_card.dart';

class SupportMessageBubble extends StatefulWidget {
  const SupportMessageBubble({super.key, required this.message});

  final SupportChatMessageModel message;

  @override
  State<SupportMessageBubble> createState() => _SupportMessageBubbleState();
}

class _SupportMessageBubbleState extends State<SupportMessageBubble> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final message = widget.message;
    final isUser = message.role == SupportChatRole.user;
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final color = isUser ? AppColors.purple : const Color(0xFFF5F7FB);
    final textColor = isUser ? Colors.white : Colors.black87;
    final canCollapseText =
        !isUser && message.text.length > 260 && !message.text.contains('\n\n');

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.text.isNotEmpty)
                _SupportExpandableText(
                  text: message.text,
                  color: textColor,
                  collapsed: canCollapseText && !_expanded,
                  onToggle:
                      canCollapseText
                          ? () => setState(() => _expanded = !_expanded)
                          : null,
                ),
              if (message.attachments.isNotEmpty || message.files.isNotEmpty) ...[
                const SizedBox(height: 10),
                _SupportAttachmentList(
                  attachments: message.attachments,
                  fallbackFileNames: message.files
                      .map((file) => file.name)
                      .toList(growable: false),
                  isUser: isUser,
                  textColor: textColor,
                ),
              ],
              if (message.analysisLabel != null &&
                  message.analysisLabel!.isNotEmpty) ...[
                const SizedBox(height: 10),
                _SupportMessageBadge(
                  text: message.analysisLabel!,
                  isUser: isUser,
                  textColor: textColor,
                ),
              ],
              if (!isUser && message.response != null) ...[
                const SizedBox(height: 16),
                SupportResponseCard(response: message.response!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SupportAttachmentList extends StatelessWidget {
  const _SupportAttachmentList({
    required this.attachments,
    required this.fallbackFileNames,
    required this.isUser,
    required this.textColor,
  });

  final List<SupportChatAttachmentModel> attachments;
  final List<String> fallbackFileNames;
  final bool isUser;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: fallbackFileNames
            .map(
              (name) => _SupportMessageBadge(
                text: name,
                isUser: isUser,
                textColor: textColor,
              ),
            )
            .toList(growable: false),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: attachments
          .map(
            (attachment) => attachment.isImage && attachment.bytes != null
                ? _SupportImageAttachment(
                    attachment: attachment,
                    isUser: isUser,
                    textColor: textColor,
                  )
                : _SupportMessageBadge(
                    text: attachment.name,
                    isUser: isUser,
                    textColor: textColor,
                  ),
          )
          .toList(growable: false),
    );
  }
}

class _SupportImageAttachment extends StatelessWidget {
  const _SupportImageAttachment({
    required this.attachment,
    required this.isUser,
    required this.textColor,
  });

  final SupportChatAttachmentModel attachment;
  final bool isUser;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isUser ? Colors.white.withValues(alpha: 0.12) : Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.memory(
              attachment.bytes!,
              width: 124,
              height: 96,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            attachment.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportExpandableText extends StatelessWidget {
  const _SupportExpandableText({
    required this.text,
    required this.color,
    required this.collapsed,
    this.onToggle,
  });

  final String text;
  final Color color;
  final bool collapsed;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          maxLines: collapsed ? 6 : null,
          overflow: collapsed ? TextOverflow.ellipsis : TextOverflow.visible,
          style: TextStyle(
            fontFamily: AppFonts.fontSubTitle,
            fontSize: 14,
            height: 1.5,
            color: color,
          ),
        ),
        if (onToggle != null) ...[
          const SizedBox(height: 8),
          TextButton(
            onPressed: onToggle,
            style: TextButton.styleFrom(
              foregroundColor: color,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              collapsed
                  ? context.l10n.support_assistant_show_more
                  : context.l10n.support_assistant_show_less,
            ),
          ),
        ],
      ],
    );
  }
}

class _SupportMessageBadge extends StatelessWidget {
  const _SupportMessageBadge({
    required this.text,
    required this.isUser,
    required this.textColor,
  });

  final String text;
  final bool isUser;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isUser ? Colors.white.withValues(alpha: 0.14) : Colors.white,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: TextStyle(color: textColor, fontSize: 12)),
    );
  }
}
