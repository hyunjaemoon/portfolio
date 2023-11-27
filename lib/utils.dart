import 'package:url_launcher/url_launcher.dart';

Map<String, String> urlMap = {
  'linkedin': 'https://www.linkedin.com/in/hyunjaemoon/',
  'github': 'https://www.github.com/hyunjaemoon/',
  'license':
      'https://github.com/hyunjaemoon/hyunjaemoon.github.io/blob/main/LICENSE',
};

Future<void> launchUrlCheck(String urlKey) async {
  String urlValue = urlMap.putIfAbsent(urlKey, () => "");
  if (urlValue.isEmpty) {
    throw Exception('urlMap key does not exist.');
  }
  Uri url = Uri.parse(urlValue);
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
