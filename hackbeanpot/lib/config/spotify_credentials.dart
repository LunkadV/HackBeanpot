import 'package:flutter/foundation.dart';

class SpotifyCredentials {
  static const String clientId = '3ac687ca3ad84d9e80501d33eda67579';
  static final String redirectUri = Uri.base.toString(); // Use dynamic web URL
  static const String scope =
      'playlist-modify-public,playlist-modify-private,user-library-read,user-top-read';

  // Add web-specific settings
  static const bool isWeb = kIsWeb;
  static const String webAuthDomain = 'accounts.spotify.com';
}
