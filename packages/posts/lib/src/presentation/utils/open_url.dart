import 'package:url_launcher/url_launcher.dart';

Future<void> openUrl(String? url) async {
  if (url == null || url.isEmpty) return;
  final uri = Uri.tryParse(url);
  if (uri == null) return;

  await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  );
}
