class MemberTodayDevotionalModel {
  final String devotionalId;
  final String scheduleDate;
  final String dayOfWeek;
  final DateTime? scheduledAt;
  final String status;
  final String title;
  final String previewText;
  final int reactionCount;
  final int commentCount;

  const MemberTodayDevotionalModel({
    required this.devotionalId,
    required this.scheduleDate,
    required this.dayOfWeek,
    required this.scheduledAt,
    required this.status,
    required this.title,
    this.previewText = '',
    this.reactionCount = 0,
    this.commentCount = 0,
  });

  factory MemberTodayDevotionalModel.fromAgendaJson(Map<String, dynamic> json) {
    return MemberTodayDevotionalModel(
      devotionalId: json['devotionalId']?.toString() ?? '',
      scheduleDate: json['scheduleDate']?.toString() ?? '',
      dayOfWeek: json['dayOfWeek']?.toString() ?? '',
      scheduledAt:
          json['scheduledAt'] != null
              ? DateTime.tryParse(json['scheduledAt'].toString())
              : null,
      status: json['status']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
    );
  }

  MemberTodayDevotionalModel copyWith({
    String? devotionalId,
    String? scheduleDate,
    String? dayOfWeek,
    DateTime? scheduledAt,
    String? status,
    String? title,
    String? previewText,
    int? reactionCount,
    int? commentCount,
  }) {
    return MemberTodayDevotionalModel(
      devotionalId: devotionalId ?? this.devotionalId,
      scheduleDate: scheduleDate ?? this.scheduleDate,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      title: title ?? this.title,
      previewText: previewText ?? this.previewText,
      reactionCount: reactionCount ?? this.reactionCount,
      commentCount: commentCount ?? this.commentCount,
    );
  }
}

class MemberDevotionalScriptureModel {
  final String reference;
  final String quote;

  const MemberDevotionalScriptureModel({
    required this.reference,
    required this.quote,
  });

  factory MemberDevotionalScriptureModel.fromJson(Map<String, dynamic> json) {
    return MemberDevotionalScriptureModel(
      reference: json['reference']?.toString() ?? '',
      quote: json['quote']?.toString() ?? '',
    );
  }
}

class MemberDevotionalDetailModel {
  final String devotionalId;
  final String scheduleDate;
  final String dayOfWeek;
  final DateTime? scheduledAt;
  final String status;
  final String title;
  final String devotional;
  final List<MemberDevotionalScriptureModel> scriptures;

  const MemberDevotionalDetailModel({
    required this.devotionalId,
    required this.scheduleDate,
    required this.dayOfWeek,
    required this.scheduledAt,
    required this.status,
    required this.title,
    required this.devotional,
    required this.scriptures,
  });

  bool get hasContent => devotional.trim().isNotEmpty;

  factory MemberDevotionalDetailModel.fromDetailResponse(
    Map<String, dynamic> response,
  ) {
    final data = Map<String, dynamic>.from(response['data'] ?? response);
    final content = Map<String, dynamic>.from(data['content'] ?? const {});
    final rawScriptures = content['scriptures'];

    return MemberDevotionalDetailModel(
      devotionalId: data['devotionalId']?.toString() ?? '',
      scheduleDate: data['scheduleDate']?.toString() ?? '',
      dayOfWeek: data['dayOfWeek']?.toString() ?? '',
      scheduledAt:
          data['scheduledAt'] != null
              ? DateTime.tryParse(data['scheduledAt'].toString())
              : null,
      status: data['status']?.toString() ?? '',
      title: content['title']?.toString() ?? data['title']?.toString() ?? '',
      devotional: content['devotional']?.toString() ?? '',
      scriptures:
          rawScriptures is List
              ? rawScriptures
                  .map(
                    (item) => MemberDevotionalScriptureModel.fromJson(
                      Map<String, dynamic>.from(item),
                    ),
                  )
                  .toList()
              : const [],
    );
  }
}

class MemberDevotionalCommentModel {
  final String commentId;
  final String memberId;
  final String authorName;
  final String message;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MemberDevotionalCommentModel({
    required this.commentId,
    required this.memberId,
    required this.authorName,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isEdited =>
      createdAt != null && updatedAt != null && updatedAt!.isAfter(createdAt!);

  factory MemberDevotionalCommentModel.fromJson(Map<String, dynamic> json) {
    return MemberDevotionalCommentModel(
      commentId: json['commentId']?.toString() ?? '',
      memberId: json['memberId']?.toString() ?? '',
      authorName: json['authorName']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'].toString())
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.tryParse(json['updatedAt'].toString())
              : null,
    );
  }
}

class MemberDevotionalCommunityModel {
  final String devotionalId;
  final Map<String, int> reactionCounts;
  final int totalReactions;
  final String? viewerReactionType;
  final int totalComments;
  final List<MemberDevotionalCommentModel> comments;

  const MemberDevotionalCommunityModel({
    required this.devotionalId,
    required this.reactionCounts,
    required this.totalReactions,
    required this.viewerReactionType,
    required this.totalComments,
    required this.comments,
  });

  factory MemberDevotionalCommunityModel.empty([String devotionalId = '']) {
    return MemberDevotionalCommunityModel(
      devotionalId: devotionalId,
      reactionCounts: const {
        'edified': 0,
        'amen': 0,
        'challenged': 0,
        'peace': 0,
        'reflect': 0,
      },
      totalReactions: 0,
      viewerReactionType: null,
      totalComments: 0,
      comments: const [],
    );
  }

  factory MemberDevotionalCommunityModel.fromResponse(
    Map<String, dynamic> response,
  ) {
    final data = Map<String, dynamic>.from(response['data'] ?? response);
    final reactions = Map<String, dynamic>.from(data['reactions'] ?? const {});
    final totals = Map<String, dynamic>.from(reactions['totals'] ?? const {});
    final comments = Map<String, dynamic>.from(data['comments'] ?? const {});
    final rawItems = comments['items'];

    return MemberDevotionalCommunityModel(
      devotionalId: data['devotionalId']?.toString() ?? '',
      reactionCounts: {
        'edified': (totals['edified'] as num?)?.toInt() ?? 0,
        'amen': (totals['amen'] as num?)?.toInt() ?? 0,
        'challenged': (totals['challenged'] as num?)?.toInt() ?? 0,
        'peace': (totals['peace'] as num?)?.toInt() ?? 0,
        'reflect': (totals['reflect'] as num?)?.toInt() ?? 0,
      },
      totalReactions: (reactions['total'] as num?)?.toInt() ?? 0,
      viewerReactionType: reactions['viewerReactionType']?.toString(),
      totalComments: (comments['total'] as num?)?.toInt() ?? 0,
      comments:
          rawItems is List
              ? rawItems
                  .map(
                    (item) => MemberDevotionalCommentModel.fromJson(
                      Map<String, dynamic>.from(item),
                    ),
                  )
                  .toList()
              : const [],
    );
  }
}
