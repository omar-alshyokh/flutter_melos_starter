extension StringX on String {
  bool get isBlank => trim().isEmpty;
}

extension UriX on Uri {
  String get domain => host.startsWith('www.') ? host.substring(4) : host;
}
