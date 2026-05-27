// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

bool isInAppBrowser() {
  try {
    final ua = html.window.navigator.userAgent;
    return RegExp(
      r'Instagram|FBAN|FBAV|Twitter\/|LinkedInApp|Snapchat|TikTok',
      caseSensitive: false,
    ).hasMatch(ua);
  } catch (_) {
    return false;
  }
}
