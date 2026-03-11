class DevotionalDayConfigModel {
  final String dayOfWeek;
  final String titleHint;
  final String biblicalContext;
  final String tone;

  const DevotionalDayConfigModel({
    required this.dayOfWeek,
    required this.titleHint,
    required this.biblicalContext,
    required this.tone,
  });

  factory DevotionalDayConfigModel.fromJson(Map<String, dynamic> json) {
    return DevotionalDayConfigModel(
      dayOfWeek: json['dayOfWeek']?.toString() ?? 'MONDAY',
      titleHint: json['titleHint']?.toString() ?? '',
      biblicalContext: json['biblicalContext']?.toString() ?? '',
      tone: json['tone']?.toString() ?? 'pastoral',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayOfWeek': dayOfWeek,
      'titleHint': titleHint,
      'biblicalContext': biblicalContext,
      'tone': tone,
    };
  }

  DevotionalDayConfigModel copyWith({
    String? dayOfWeek,
    String? titleHint,
    String? biblicalContext,
    String? tone,
  }) {
    return DevotionalDayConfigModel(
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      titleHint: titleHint ?? this.titleHint,
      biblicalContext: biblicalContext ?? this.biblicalContext,
      tone: tone ?? this.tone,
    );
  }
}

class DevotionalPlanChannelsModel {
  final bool pushEnabled;
  final bool whatsappEnabled;

  const DevotionalPlanChannelsModel({
    required this.pushEnabled,
    required this.whatsappEnabled,
  });

  factory DevotionalPlanChannelsModel.fromJson(Map<String, dynamic> json) {
    return DevotionalPlanChannelsModel(
      pushEnabled: json['pushEnabled'] == true,
      whatsappEnabled: json['whatsappEnabled'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {'pushEnabled': pushEnabled, 'whatsappEnabled': whatsappEnabled};
  }

  DevotionalPlanChannelsModel copyWith({
    bool? pushEnabled,
    bool? whatsappEnabled,
  }) {
    return DevotionalPlanChannelsModel(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      whatsappEnabled: whatsappEnabled ?? this.whatsappEnabled,
    );
  }
}

class DevotionalPlanModel {
  final String devotionalWeeklyPlanId;
  final String weekStartDate;
  final bool isEnabled;
  final String themeWeek;
  final List<String> daysOfWeek;
  final String sendTime;
  final String timezone;
  final String audience;
  final DevotionalPlanChannelsModel channels;
  final String mode;
  final List<DevotionalDayConfigModel> dayConfigs;

  const DevotionalPlanModel({
    required this.devotionalWeeklyPlanId,
    required this.weekStartDate,
    required this.isEnabled,
    required this.themeWeek,
    required this.daysOfWeek,
    required this.sendTime,
    required this.timezone,
    required this.audience,
    required this.channels,
    required this.mode,
    required this.dayConfigs,
  });

  factory DevotionalPlanModel.empty(String weekStartDate) {
    return DevotionalPlanModel(
      devotionalWeeklyPlanId: '',
      weekStartDate: weekStartDate,
      isEnabled: true,
      themeWeek: '',
      daysOfWeek: const ['MONDAY'],
      sendTime: '06:00',
      timezone: 'America/Sao_Paulo',
      audience: 'all',
      channels: const DevotionalPlanChannelsModel(
        pushEnabled: true,
        whatsappEnabled: false,
      ),
      mode: 'review',
      dayConfigs: const [
        DevotionalDayConfigModel(
          dayOfWeek: 'MONDAY',
          titleHint: '',
          biblicalContext: '',
          tone: 'pastoral',
        ),
      ],
    );
  }

  factory DevotionalPlanModel.fromJson(Map<String, dynamic> json) {
    final rawConfigs = json['dayConfigs'];
    final rawDays = json['daysOfWeek'];

    return DevotionalPlanModel(
      devotionalWeeklyPlanId: json['devotionalWeeklyPlanId']?.toString() ?? '',
      weekStartDate: json['weekStartDate']?.toString() ?? '',
      isEnabled: json['isEnabled'] == true,
      themeWeek: json['themeWeek']?.toString() ?? '',
      daysOfWeek:
          rawDays is List
              ? rawDays.map((e) => e.toString()).toList()
              : const [],
      sendTime: json['sendTime']?.toString() ?? '06:00',
      timezone: json['timezone']?.toString() ?? 'America/Sao_Paulo',
      audience: json['audience']?.toString() ?? 'all',
      channels: DevotionalPlanChannelsModel.fromJson(
        Map<String, dynamic>.from(json['channels'] ?? const {}),
      ),
      mode: json['mode']?.toString() ?? 'review',
      dayConfigs:
          rawConfigs is List
              ? rawConfigs
                  .map(
                    (e) => DevotionalDayConfigModel.fromJson(
                      Map<String, dynamic>.from(e),
                    ),
                  )
                  .toList()
              : const [],
    );
  }

  Map<String, dynamic> toUpsertPayload() {
    return {
      'weekStartDate': weekStartDate,
      'isEnabled': isEnabled,
      'themeWeek': themeWeek,
      'daysOfWeek': daysOfWeek,
      'sendTime': sendTime,
      'timezone': timezone,
      'audience': audience,
      'channels': channels.toJson(),
      'requiresPastorReview': mode == 'review',
      'mode': mode,
      'dayConfigs': dayConfigs.map((e) => e.toJson()).toList(),
    };
  }

  DevotionalPlanModel copyWith({
    String? devotionalWeeklyPlanId,
    String? weekStartDate,
    bool? isEnabled,
    String? themeWeek,
    List<String>? daysOfWeek,
    String? sendTime,
    String? timezone,
    String? audience,
    DevotionalPlanChannelsModel? channels,
    String? mode,
    List<DevotionalDayConfigModel>? dayConfigs,
  }) {
    return DevotionalPlanModel(
      devotionalWeeklyPlanId:
          devotionalWeeklyPlanId ?? this.devotionalWeeklyPlanId,
      weekStartDate: weekStartDate ?? this.weekStartDate,
      isEnabled: isEnabled ?? this.isEnabled,
      themeWeek: themeWeek ?? this.themeWeek,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      sendTime: sendTime ?? this.sendTime,
      timezone: timezone ?? this.timezone,
      audience: audience ?? this.audience,
      channels: channels ?? this.channels,
      mode: mode ?? this.mode,
      dayConfigs: dayConfigs ?? this.dayConfigs,
    );
  }
}

class DevotionalAgendaItemModel {
  final String devotionalId;
  final String scheduleDate;
  final String dayOfWeek;
  final DateTime? scheduledAt;
  final String status;
  final String audience;
  final String mode;
  final bool pushEnabled;
  final bool whatsappEnabled;
  final String pushResult;
  final String whatsappResult;
  final String? title;
  final bool isLate;

  const DevotionalAgendaItemModel({
    required this.devotionalId,
    required this.scheduleDate,
    required this.dayOfWeek,
    required this.scheduledAt,
    required this.status,
    required this.audience,
    required this.mode,
    required this.pushEnabled,
    required this.whatsappEnabled,
    required this.pushResult,
    required this.whatsappResult,
    required this.title,
    required this.isLate,
  });

  factory DevotionalAgendaItemModel.fromJson(Map<String, dynamic> json) {
    final channels = Map<String, dynamic>.from(json['channels'] ?? const {});

    return DevotionalAgendaItemModel(
      devotionalId: json['devotionalId']?.toString() ?? '',
      scheduleDate: json['scheduleDate']?.toString() ?? '',
      dayOfWeek: json['dayOfWeek']?.toString() ?? '',
      scheduledAt:
          json['scheduledAt'] != null
              ? DateTime.tryParse(json['scheduledAt'].toString())
              : null,
      status: json['status']?.toString() ?? 'pending',
      audience: json['audience']?.toString() ?? 'all',
      mode: json['mode']?.toString() ?? 'review',
      pushEnabled: channels['pushEnabled'] == true,
      whatsappEnabled: channels['whatsappEnabled'] == true,
      pushResult: json['pushResult']?.toString() ?? 'not_enabled',
      whatsappResult: json['whatsappResult']?.toString() ?? 'not_enabled',
      title: json['title']?.toString(),
      isLate: json['isLate'] == true,
    );
  }
}

class DevotionalAgendaResponseModel {
  final String weekStartDate;
  final DateTime? nextSendAt;
  final int inReviewCount;
  final List<DevotionalAgendaItemModel> items;

  const DevotionalAgendaResponseModel({
    required this.weekStartDate,
    required this.nextSendAt,
    required this.inReviewCount,
    required this.items,
  });

  factory DevotionalAgendaResponseModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    return DevotionalAgendaResponseModel(
      weekStartDate: json['weekStartDate']?.toString() ?? '',
      nextSendAt:
          json['nextSendAt'] != null
              ? DateTime.tryParse(json['nextSendAt'].toString())
              : null,
      inReviewCount:
          int.tryParse(json['inReviewCount']?.toString() ?? '0') ?? 0,
      items:
          rawItems is List
              ? rawItems
                  .map(
                    (e) => DevotionalAgendaItemModel.fromJson(
                      Map<String, dynamic>.from(e),
                    ),
                  )
                  .toList()
              : const [],
    );
  }
}

class DevotionalScriptureModel {
  final String reference;
  final String quote;

  const DevotionalScriptureModel({
    required this.reference,
    required this.quote,
  });

  factory DevotionalScriptureModel.fromJson(Map<String, dynamic> json) {
    return DevotionalScriptureModel(
      reference: json['reference']?.toString() ?? '',
      quote: json['quote']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'reference': reference, 'quote': quote};
  }
}

class DevotionalContentModel {
  final String title;
  final String devotional;
  final String pushTitle;
  final String pushBody;
  final List<DevotionalScriptureModel> scriptures;

  const DevotionalContentModel({
    required this.title,
    required this.devotional,
    required this.pushTitle,
    required this.pushBody,
    required this.scriptures,
  });

  factory DevotionalContentModel.fromJson(Map<String, dynamic> json) {
    final rawScriptures = json['scriptures'];

    return DevotionalContentModel(
      title: json['title']?.toString() ?? '',
      devotional: json['devotional']?.toString() ?? '',
      pushTitle: json['pushTitle']?.toString() ?? '',
      pushBody: json['pushBody']?.toString() ?? '',
      scriptures:
          rawScriptures is List
              ? rawScriptures
                  .map(
                    (e) => DevotionalScriptureModel.fromJson(
                      Map<String, dynamic>.from(e),
                    ),
                  )
                  .toList()
              : const [],
    );
  }

  Map<String, dynamic> toUpdatePayload() {
    return {
      'title': title,
      'devotional': devotional,
      'pushTitle': pushTitle,
      'pushBody': pushBody,
      'scriptures': scriptures.map((e) => e.toJson()).toList(),
    };
  }

  DevotionalContentModel copyWith({
    String? title,
    String? devotional,
    String? pushTitle,
    String? pushBody,
    List<DevotionalScriptureModel>? scriptures,
  }) {
    return DevotionalContentModel(
      title: title ?? this.title,
      devotional: devotional ?? this.devotional,
      pushTitle: pushTitle ?? this.pushTitle,
      pushBody: pushBody ?? this.pushBody,
      scriptures: scriptures ?? this.scriptures,
    );
  }
}

class DevotionalDetailModel {
  final DevotionalAgendaItemModel item;
  final DevotionalContentModel? content;

  const DevotionalDetailModel({required this.item, required this.content});

  factory DevotionalDetailModel.fromJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json['data'] ?? json);
    return DevotionalDetailModel(
      item: DevotionalAgendaItemModel.fromJson(data),
      content:
          data['content'] != null
              ? DevotionalContentModel.fromJson(
                Map<String, dynamic>.from(data['content']),
              )
              : null,
    );
  }
}

class DevotionalHistoryItemModel {
  final String devotionalDeliveryLogId;
  final String devotionalId;
  final String scheduleDate;
  final DateTime? attemptedAt;
  final String audience;
  final String themeWeek;
  final String overall;
  final String push;
  final String whatsapp;
  final String title;

  const DevotionalHistoryItemModel({
    required this.devotionalDeliveryLogId,
    required this.devotionalId,
    required this.scheduleDate,
    required this.attemptedAt,
    required this.audience,
    required this.themeWeek,
    required this.overall,
    required this.push,
    required this.whatsapp,
    required this.title,
  });

  factory DevotionalHistoryItemModel.fromJson(Map<String, dynamic> json) {
    final results = Map<String, dynamic>.from(json['results'] ?? const {});
    final snapshot = Map<String, dynamic>.from(
      json['contentSnapshot'] ?? const {},
    );

    return DevotionalHistoryItemModel(
      devotionalDeliveryLogId:
          json['devotionalDeliveryLogId']?.toString() ?? '',
      devotionalId: json['devotionalId']?.toString() ?? '',
      scheduleDate: json['scheduleDate']?.toString() ?? '',
      attemptedAt:
          json['attemptedAt'] != null
              ? DateTime.tryParse(json['attemptedAt'].toString())
              : null,
      audience: json['audience']?.toString() ?? 'all',
      themeWeek: json['themeWeek']?.toString() ?? '',
      overall: results['overall']?.toString() ?? 'error',
      push: results['push']?.toString() ?? 'not_enabled',
      whatsapp: results['whatsapp']?.toString() ?? 'not_enabled',
      title: snapshot['title']?.toString() ?? '',
    );
  }
}

class DevotionalHistoryResponseModel {
  final int total;
  final int sent;
  final int partial;
  final int error;
  final List<DevotionalHistoryItemModel> items;

  const DevotionalHistoryResponseModel({
    required this.total,
    required this.sent,
    required this.partial,
    required this.error,
    required this.items,
  });

  factory DevotionalHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    final metrics = Map<String, dynamic>.from(json['metrics'] ?? const {});
    final rawItems = json['items'];

    return DevotionalHistoryResponseModel(
      total: int.tryParse(metrics['total']?.toString() ?? '0') ?? 0,
      sent: int.tryParse(metrics['sent']?.toString() ?? '0') ?? 0,
      partial: int.tryParse(metrics['partial']?.toString() ?? '0') ?? 0,
      error: int.tryParse(metrics['error']?.toString() ?? '0') ?? 0,
      items:
          rawItems is List
              ? rawItems
                  .map(
                    (e) => DevotionalHistoryItemModel.fromJson(
                      Map<String, dynamic>.from(e),
                    ),
                  )
                  .toList()
              : const [],
    );
  }
}
