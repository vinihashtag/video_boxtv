class RestClientExceptionModel implements Exception {
  final String message;
  final int? statusCode;
  final dynamic error;
  final StackTrace? stackTrace;

  RestClientExceptionModel({
    this.message = '',
    this.statusCode,
    this.error,
    this.stackTrace,
  });
}
