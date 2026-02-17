class NetworkException implements Exception {
  final String message;
  final Object? cause;
  const NetworkException(this.message, {this.cause});
}

class UnknownException implements Exception {
  final String message;
  final Object? cause;
  const UnknownException(this.message, {this.cause});
}
