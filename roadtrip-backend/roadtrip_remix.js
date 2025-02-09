require('dotenv').config();
const express = require('express');
const cors = require('cors');
const SpotifyWebApi = require('spotify-web-api-node');
const axios = require('axios');

const app = express();
app.use(cors());
app.use(express.json());

const spotifyApi = new SpotifyWebApi({
  clientId: process.env.SPOTIFY_CLIENT_ID,
  clientSecret: process.env.SPOTIFY_CLIENT_SECRET,
  redirectUri: process.env.SPOTIFY_REDIRECT_URI,
});

// Authorization Endpoint
app.get('/authorize', (req, res) => {
  const scopes = ['user-read-private', 'user-read-email', 'playlist-modify-public'];
  const authorizeURL = spotifyApi.createAuthorizeURL(scopes, 'some-state-of-your-choice');
  res.json({ url: authorizeURL });
});

// Callback Endpoint
app.get('/callback', async (req, res) => {
  const { code } = req.query;
  try {
    const data = await spotifyApi.authorizationCodeGrant(code);
    const { access_token, refresh_token } = data.body;
    spotifyApi.setAccessToken(access_token);
    spotifyApi.setRefreshToken(refresh_token);

    // You might want to store these tokens securely for the user
    res.send('Authorization successful! You can now use the API.');
  } catch (err) {
    console.error('Authorization error:', err);
    res.status(400).send('Authorization failed.');
  }
});

// Location to Genre Mapping (Example)
const locationGenres = {
  city: ['hip-hop', 'pop', 'electronic'],
  country: ['country', 'folk', 'acoustic'],
  rural: ['ambient', 'chill', 'lo-fi'],
  oldmoney: ['jazz', 'classical', 'swing'],
};

//Playlist Generation endpoint
app.get('/generate-playlist', async (req, res) => {
    const { locationType } = req.query;
    const genres = locationGenres[locationType] || ['pop']; // Default to 'pop' if location not found
    try {
        const playlist = await generatePlaylist(genres);
        res.json(playlist);
    } catch (error) {
        console.error('Error generating playlist:', error);
        res.status(500).json({ error: 'Failed to generate playlist' });
    }
});

async function generatePlaylist(genres) {
    // Get recommendations based on genres
    const recommendations = await spotifyApi.getRecommendations({
        seed_genres: genres,
        limit: 20,
    });

    // Extract track URIs from recommendations
    const trackUris = recommendations.body.tracks.map(track => track.uri);

    // Create a new playlist
    const user = await spotifyApi.getMe();
    const playlistName = `Roadtrip Remix - ${new Date().toLocaleDateString()}`;
    const playlistDescription = `Generated for your roadtrip, featuring ${genres.join(', ')} vibes.`;
    const createPlaylistResponse = await spotifyApi.createPlaylist(user.body.id, playlistName, {
        public: false,
        description: playlistDescription,
    });

    const playlistId = createPlaylistResponse.body.id;

    // Add tracks to the playlist
    await spotifyApi.addTracksToPlaylist(playlistId, trackUris);

    return {
        playlistId: playlistId,
        playlistName: playlistName,
        playlistUrl: `https://open.spotify.com/playlist/${playlistId}`,
    };
}
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
