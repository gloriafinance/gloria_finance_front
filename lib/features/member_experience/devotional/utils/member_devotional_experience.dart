String devotionalPreviewText(String text, {int maxLength = 140}) {
  final normalized = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (normalized.isEmpty) {
    return '';
  }
  if (normalized.length <= maxLength) {
    return normalized;
  }
  return '${normalized.substring(0, maxLength).trimRight()}...';
}

String devotionalHighlightText(String text, {int maxLength = 150}) {
  final normalized = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (normalized.isEmpty) {
    return '';
  }

  final sentences =
      normalized
          .split(RegExp(r'(?<=[.!?])\s+'))
          .map((sentence) => sentence.trim())
          .where((sentence) => sentence.isNotEmpty)
          .toList();

  for (final sentence in sentences) {
    if (sentence.length >= 48 && sentence.length <= maxLength) {
      return sentence;
    }
  }

  return devotionalPreviewText(normalized, maxLength: maxLength);
}

String devotionalShareBody(String text) {
  return text
      .split(RegExp(r'\n\s*\n'))
      .map((paragraph) => paragraph.trim())
      .where((paragraph) => paragraph.isNotEmpty)
      .join('\n\n');
}
