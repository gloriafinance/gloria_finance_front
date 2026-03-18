class DevotionalCommunityCommentModel {
  final String commentId;
  final String authorName;
  final String message;
  final DateTime? createdAt;

  const DevotionalCommunityCommentModel({
    required this.commentId,
    required this.authorName,
    required this.message,
    required this.createdAt,
  });

  factory DevotionalCommunityCommentModel.fromJson(Map<String, dynamic> json) {
    return DevotionalCommunityCommentModel(
      commentId: json['commentId']?.toString() ?? '',
      authorName: json['authorName']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'].toString())
              : null,
    );
  }
}

class DevotionalCommunityInsightsModel {
  final String devotionalId;
  final Map<String, int> reactionCounts;
  final int totalReactions;
  final int totalComments;
  final List<DevotionalCommunityCommentModel> comments;

  const DevotionalCommunityInsightsModel({
    required this.devotionalId,
    required this.reactionCounts,
    required this.totalReactions,
    required this.totalComments,
    required this.comments,
  });

  factory DevotionalCommunityInsightsModel.fromResponse(
    Map<String, dynamic> response,
  ) {
    final data = Map<String, dynamic>.from(response['data'] ?? response);
    final reactions = Map<String, dynamic>.from(data['reactions'] ?? const {});
    final totals = Map<String, dynamic>.from(reactions['totals'] ?? const {});
    final comments = Map<String, dynamic>.from(data['comments'] ?? const {});
    final rawItems = comments['items'];

    return DevotionalCommunityInsightsModel(
      devotionalId: data['devotionalId']?.toString() ?? '',
      reactionCounts: {
        'edified': (totals['edified'] as num?)?.toInt() ?? 0,
        'amen': (totals['amen'] as num?)?.toInt() ?? 0,
        'challenged': (totals['challenged'] as num?)?.toInt() ?? 0,
        'peace': (totals['peace'] as num?)?.toInt() ?? 0,
        'reflect': (totals['reflect'] as num?)?.toInt() ?? 0,
      },
      totalReactions: (reactions['total'] as num?)?.toInt() ?? 0,
      totalComments: (comments['total'] as num?)?.toInt() ?? 0,
      comments:
          rawItems is List
              ? rawItems
                  .map(
                    (item) => DevotionalCommunityCommentModel.fromJson(
                      Map<String, dynamic>.from(item),
                    ),
                  )
                  .toList()
              : const [],
    );
  }

  bool get hasEngagement => totalReactions > 0 || totalComments > 0;
}
