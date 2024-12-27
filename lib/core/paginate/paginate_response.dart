class PaginateResponse<T> {
  bool nextPag;
  final int count;
  final List<T> results;
  final int perPage;

  PaginateResponse({
    this.nextPag = false,
    required this.count,
    required this.results,
    required this.perPage,
  });

  factory PaginateResponse.init() {
    return PaginateResponse(nextPag: false, count: 0, results: [], perPage: 10);
  }

  factory PaginateResponse.fromJson(perPage, Map<dynamic, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT) {
    final List<dynamic> resultsJson = json['results'];
    final List<T> results =
        resultsJson.map((result) => fromJsonT(result)).toList();

    final nextPage = (json['nextPag'] == null) ? false : true;
    return PaginateResponse(
      nextPag: nextPage,
      count: json['count'],
      results: results,
      perPage: perPage,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'nextPag': nextPag == 0 ? null : nextPag,
      'count': count,
      'results': results,
      'perPage': perPage,
    };
  }
}
