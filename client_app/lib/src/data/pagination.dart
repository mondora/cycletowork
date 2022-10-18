class Pagination {
  final bool hasNextPage;
  final String? nextPageToken;

  Pagination({
    required this.hasNextPage,
    this.nextPageToken,
  });

  Pagination.fromMap(Map<String, dynamic> map)
      : hasNextPage = map['hasNextPage'],
        nextPageToken = map['nextPageToken'];
}
