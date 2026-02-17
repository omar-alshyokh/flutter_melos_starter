enum FailureType {
  network,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  server,
  cancelled,
  parsing,
  unknown,
  validation,
  conflict,
}

class Failure {
  final FailureType type;
  final String message;
  final String? code; // http code or app code
  final Object? cause;

  const Failure({
    required this.type,
    required this.message,
    this.code,
    this.cause,
  });

  bool get isNetwork => type == FailureType.network || type == FailureType.timeout;
}
