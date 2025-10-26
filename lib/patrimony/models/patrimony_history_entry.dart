import 'package:intl/intl.dart';

class PatrimonyHistoryEntry {
  final String action;
  final String? performedBy;
  final DateTime? performedAt;
  final String? notes;
  final Map<String, dynamic> changes;

  PatrimonyHistoryEntry({
    required this.action,
    this.performedBy,
    this.performedAt,
    this.notes,
    required this.changes,
  });

  factory PatrimonyHistoryEntry.fromMap(Map<String, dynamic> map) {
    return PatrimonyHistoryEntry(
      action: map['action'] as String? ?? '',
      performedBy: map['performedBy'] as String?,
      performedAt: map['performedAt'] != null
          ? DateTime.tryParse(map['performedAt'] as String)
          : null,
      notes: map['notes'] as String?,
      changes: Map<String, dynamic>.from(map['changes'] as Map? ?? {}),
    );
  }

  String get performedAtLabel {
    if (performedAt == null) {
      return '';
    }

    return DateFormat('dd/MM/yyyy HH:mm').format(performedAt!);
  }

  List<String> get formattedChanges {
    if (changes.isEmpty) {
      return const [];
    }

    return changes.entries.map((entry) {
      final current = (entry.value as Map?)?.containsKey('current') == true
          ? (entry.value as Map)['current']
          : entry.value;
      return '${entry.key}: $current';
    }).toList();
  }
}
