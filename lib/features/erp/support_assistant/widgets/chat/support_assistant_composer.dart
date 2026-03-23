import 'package:flutter/material.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';

class SupportAssistantComposer extends StatelessWidget {
  const SupportAssistantComposer({
    super.key,
    required this.controller,
    required this.isCompact,
    required this.isLoading,
    required this.onAttach,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isCompact;
  final bool isLoading;
  final VoidCallback onAttach;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child:
          isCompact
              ? Column(
                children: [
                  _SupportAssistantInputField(
                    controller: controller,
                    hintText: l10n.support_assistant_input_hint,
                    onSubmitted: (_) => onSend(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: isLoading ? null : onAttach,
                          icon: const Icon(Icons.attach_file),
                          label: _ButtonLabel(
                            text: l10n.support_assistant_action_attach,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: isLoading ? null : onSend,
                          icon: const Icon(Icons.send),
                          label: _ButtonLabel(
                            text: l10n.support_assistant_action_send,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
              : Row(
                children: [
                  IconButton(
                    onPressed: isLoading ? null : onAttach,
                    icon: const Icon(Icons.attach_file),
                  ),
                  Expanded(
                    child: _SupportAssistantInputField(
                      controller: controller,
                      hintText: l10n.support_assistant_input_hint,
                      onSubmitted: (_) => onSend(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: isLoading ? null : onSend,
                    icon: const Icon(Icons.send),
                    label: Text(l10n.support_assistant_action_send),
                  ),
                ],
              ),
    );
  }
}

class _SupportAssistantInputField extends StatelessWidget {
  const _SupportAssistantInputField({
    required this.controller,
    required this.hintText,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: 1,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      onSubmitted: onSubmitted,
    );
  }
}

class _ButtonLabel extends StatelessWidget {
  const _ButtonLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
    );
  }
}
