import 'package:spotify_sdk/spotify_sdk.dart';
import '../config/spotify_credentials.dart';

class SpotifyService {
  static final SpotifyService _instance = SpotifyService._internal();
  factory SpotifyService() => _instance;
  SpotifyService._internal();

  Future<bool> connectToSpotify() async {
    try {
      final result = await SpotifySdk.connectToSpotifyRemote(
        clientId: SpotifyCredentials.clientId,
        redirectUrl: SpotifyCredentials.redirectUri,
        scope: SpotifyCredentials.scope,
      );
      return result;
    } catch (e) {
      print('Spotify connection error: $e');
      return false;
    }
  }

  Future<void> createLocationBasedPlaylist(
      String locationName, String locationType) async {
    if (!await connectToSpotify()) {
      throw Exception('Failed to connect to Spotify');
    }

    // Map location types to genres
    final Map<String, List<String>> locationGenres = {
      'city': ['pop', 'electronic', 'hip-hop'],
      'rural': ['country', 'folk', 'acoustic'],
      'coastal': ['reggae', 'surf rock', 'tropical'],
      'mountain': ['folk', 'indie', 'alternative'],
      'unknown': ['pop', 'rock', 'indie'],
    };

    final genres = locationGenres[locationType] ?? locationGenres['unknown']!;
    final playlistName = '$locationName Vibes';

    try {
      // Launch Spotify app with playlist creation
      await SpotifySdk.play(
        spotifyUri: 'spotify:app:playlist:create',
        asRadio: true,
      );
    } catch (e) {
      throw Exception('Failed to create playlist: $e');
    }
  }

  Future<void> createPersonalizedPlaylist() async {
    if (!await connectToSpotify()) {
      throw Exception('Failed to connect to Spotify');
    }

    try {
      await SpotifySdk.play(
        spotifyUri: 'spotify:app:playlist:create:fromrecommendations',
      );
    } catch (e) {
      throw Exception('Failed to create personalized playlist: $e');
    }
  }
}
