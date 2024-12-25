class PaginateResponse<T> {
  int nextPag;
  final int count;
  final List<T> results;

  PaginateResponse({
    this.nextPag = 0,
    required this.count,
    required this.results,
  });

  factory PaginateResponse.init() {
    return PaginateResponse(nextPag: 0, count: 0, results: []);
  }

  factory PaginateResponse.fromJson(
      Map<dynamic, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    final List<dynamic> resultsJson = json['results'];
    final List<T> results =
        resultsJson.map((result) => fromJsonT(result)).toList();

    return PaginateResponse(
      nextPag: (json['nextPag'] == null) ? 0 : json['nextPag'],
      count: json['count'],
      results: results,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'nextPag': nextPag == 0 ? null : nextPag,
      'count': count,
      'results': results,
    };
  }
}
