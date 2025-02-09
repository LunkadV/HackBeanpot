import 'package:spotify_sdk/spotify_sdk.dart';
import '../config/spotify_credentials.dart';

class SpotifyService {
  Future<bool> connectToSpotify() async {
    try {
      return await SpotifySdk.connectToSpotifyRemote(
        clientId: SpotifyCredentials.clientId,
        redirectUrl: SpotifyCredentials.redirectUri,
      );
    } catch (e) {
      print('Failed to connect to Spotify: $e');
      return false;
    }
  }

  Future<void> createLocationBasedPlaylist(
      String locationName, String type) async {
    if (!await connectToSpotify()) {
      throw Exception('Failed to connect to Spotify');
    }

    // Define genres based on location type
    Map<String, List<String>> locationGenres = {
      'city': ['pop', 'rap', 'electronic'],
      'rural': ['country', 'folk', 'acoustic'],
      'coastal': ['reggae', 'surf rock', 'tropical'],
      'mountain': ['folk', 'indie', 'alternative'],
    };

    // Create and populate playlist based on location type
    await SpotifySdk.play(spotifyUri: 'spotify:app:playlist:create');
  }

  Future<void> createPersonalizedPlaylist() async {
    if (!await connectToSpotify()) {
      throw Exception('Failed to connect to Spotify');
    }

    await SpotifySdk.play(
      spotifyUri: 'spotify:app:playlist:create:fromrecommendations',
    );
  }
}
