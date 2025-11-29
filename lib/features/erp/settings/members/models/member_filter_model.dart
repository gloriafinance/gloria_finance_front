class MemberFilterModel {
  int perPage;
  int page;
  String churchId;

  MemberFilterModel({
    this.perPage = 20,
    this.page = 1,
    required this.churchId,
  });

  factory MemberFilterModel.init() {
    return MemberFilterModel(
      churchId: '',
    );
  }

  MemberFilterModel copyWith({
    int? perPage,
    int? page,
    String? churchId,
  }) {
    return MemberFilterModel(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      churchId: churchId ?? this.churchId,
    );
  }

  toJson() {
    return {
      'perPage': perPage,
      'page': page,
      'churchId': churchId,
    };
  }
}
