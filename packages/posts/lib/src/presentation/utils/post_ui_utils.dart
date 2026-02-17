import 'dart:core';

String? domainFromUrl(String? url) {
  if (url == null || url.isEmpty) return null;
  try {
    final uri = Uri.parse(url);
    final host = uri.host;
    if (host.isEmpty) return null;
    return host.startsWith('www.') ? host.substring(4) : host;
  } catch (_) {
    return null;
  }
}

String timeAgoFromUnixSeconds(int? unixSeconds) {
  if (unixSeconds == null || unixSeconds <= 0) return '';
  final dt = DateTime.fromMillisecondsSinceEpoch(unixSeconds * 1000, isUtc: true).toLocal();
  final diff = DateTime.now().difference(dt);

  if (diff.inMinutes < 1) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m';
  if (diff.inHours < 24) return '${diff.inHours}h';
  return '${diff.inDays}d';
}
