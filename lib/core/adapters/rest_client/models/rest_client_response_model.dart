class RestClientResponseModel {
  final dynamic data;
  final int? statusCode;
  final String? statusMessage;

  RestClientResponseModel({
    this.data,
    this.statusCode,
    this.statusMessage,
  });

  bool get isSucess => data == null;
}
