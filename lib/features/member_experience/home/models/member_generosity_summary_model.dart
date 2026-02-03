class MemberGenerositySummaryModel {
  final double contributedYear;
  final double contributedMonth;
  final int activeCommitments;

  const MemberGenerositySummaryModel({
    required this.contributedYear,
    required this.contributedMonth,
    required this.activeCommitments,
  });

  factory MemberGenerositySummaryModel.fromJson(Map<String, dynamic> json) {
    return MemberGenerositySummaryModel(
      contributedYear: (json['contributedYear'] ?? 0).toDouble(),
      contributedMonth: (json['contributedMonth'] ?? 0).toDouble(),
      activeCommitments: (json['activeCommitments'] ?? 0).toInt(),
    );
  }

  const MemberGenerositySummaryModel.empty()
    : contributedYear = 0,
      contributedMonth = 0,
      activeCommitments = 0;
}
