import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Map<String, String> urlMap = {
  'linkedin': 'https://www.linkedin.com/in/hyunjaemoon/',
  'github': 'https://www.github.com/hyunjaemoon/',
  'license':
      'https://github.com/hyunjaemoon/hyunjaemoon.github.io/blob/main/LICENSE',
  'aosp':
      'https://android-review.googlesource.com/q/owner:hyunjaemoon@google.com',
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

TextStyle fitTextStyle(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final textScaleFactor = size.width / 500;
  return TextStyle(fontSize: 24 * textScaleFactor);
}
