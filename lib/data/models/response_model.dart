class ResponseModel<D extends dynamic, E extends dynamic> {
  final D? data;
  final E? error;
  final bool? hasMoreData;
  final int? totalItems;
  final int? lastItemId;
  final int? statusCode;
  final String? query;

  ResponseModel({
    this.data,
    this.error,
    this.hasMoreData,
    this.totalItems,
    this.lastItemId,
    this.statusCode,
    this.query,
  });

  bool get isSuccess => data != null;
  bool get isError => error != null;

  factory ResponseModel.fromPagination(D data, dynamic pagination) {
    return ResponseModel(
      data: data,
      hasMoreData: pagination?['nextPage'] != null,
      lastItemId: pagination?['nextPage'],
      totalItems: pagination?['totalItems'],
    );
  }

  factory ResponseModel.fromPaginationTotalCount(D data, dynamic pagination) {
    final int totalCount = pagination?['totalCount'] ?? 0;
    final hasMoreData = (pagination?['items'] as List).isNotEmpty;
    return ResponseModel(data: data, hasMoreData: hasMoreData, totalItems: totalCount);
  }

  factory ResponseModel.fromPaginationLastId(D data, dynamic pagination) {
    return ResponseModel(
      data: data,
      hasMoreData: pagination?['hasMoreItems'],
      lastItemId: pagination?['lastId'],
      totalItems: pagination?['totalCount'],
    );
  }

  factory ResponseModel.fromSearch(D data, dynamic pagination) {
    String query = '';

    try {
      if (pagination?['nextPage'] != null) {
        final result = (pagination['nextPage'] as String).split('cursor=');
        if (result.isNotEmpty && result.last.isNotEmpty) {
          query = result.last;
        }
      }
    } catch (e) {
      query = '';
    }

    return ResponseModel(
      data: data,
      hasMoreData: query.isNotEmpty,
      query: query,
    );
  }
}
