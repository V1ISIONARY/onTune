const express = require('express');
const cors = require('cors');
const { execFile } = require('child_process');
const path = require('path');
const app = express();

// Enable CORS for all requests
app.use(cors());

// Function to convert music.youtube.com URL to youtube.com URL
const convertMusicUrlToYouTubeUrl = (musicUrl) => {
    console.log("Original URL:", musicUrl); // Debugging print
    if (musicUrl.includes('music.youtube.com')) {
        const convertedUrl = musicUrl.replace('music.youtube.com', 'www.youtube.com');
        console.log("Converted URL:", convertedUrl); // Debugging print
        return convertedUrl;
    }
    return musicUrl;
};

// Route to get the audio
app.get('/get-audio', (req, res) => {

    const propertyUrl = req.query.url;

    if (!propertyUrl) {
        return res.status(400).json({ error: 'URL parameter is required' });
    }

    const youtubeUrl = convertMusicUrlToYouTubeUrl(propertyUrl);

    console.log("Final YouTube URL to process:", youtubeUrl);

    const urlPattern = /^(https?:\/\/)?(www\.)?(youtube|music\.youtube)\.com/;
    if (!urlPattern.test(youtubeUrl)) {
        console.error("Invalid URL format:", youtubeUrl);
        return res.status(400).json({ error: 'Invalid video URL format' });
    }

    const pythonScript = path.resolve(__dirname, 'functions', 'get_audio.py');

    execFile('python3', [pythonScript, youtubeUrl], (error, stdout, stderr) => {
        if (error) {
            console.error('Error executing Python script:', stderr);
            return res.status(500).json({ error: 'Error fetching audio stream' });
        }

        try {
            const result = JSON.parse(stdout);

            if (result.error) {
                console.error('Error in result:', result.error);
                return res.status(500).json({ error: result.error });
            }

            // Send the result (audio URL, title, writer, and lyrics URL) as JSON
            res.json(result);

        } catch (parseError) {
            console.error('Error parsing JSON:', parseError);
            return res.status(500).json({ error: 'Error parsing response from Python script' });
        }
    });

});

app.get('/fetch-randomized-playlist', async (req, res) => {
    // Log received query parameters for debugging
    console.log('Received query:', req.query);

    // Ensure `urls[]` is an array (query parameters are automatically parsed into an array if there are multiple values)
    const randomizedUrls = req.query.urls;

    // If `urls[]` is not present or it's not an array, return an error
    if (!randomizedUrls || !Array.isArray(randomizedUrls)) {
        return res.status(400).json({ error: 'URLs parameter must be an array' });
    }

    // Validate that each URL is in the correct format
    const urlPattern = /^(https?:\/\/)?(www\.)?(youtube|music\.youtube)\.com\/playlist\?list=/;
    for (const url of randomizedUrls) {
        if (!urlPattern.test(url)) {
            console.error("Invalid URL format:", url);
            return res.status(400).json({ error: 'Invalid YouTube playlist URL format' });
        }
    }

    // Helper function to fetch playlist details using the Python script
    const fetchPlaylistDetails = (playlistUrl) => {
        return new Promise((resolve, reject) => {
            const pythonScript = path.resolve(__dirname, 'functions', 'ramdomized.py');
            execFile('python3', [pythonScript, playlistUrl], (error, stdout, stderr) => {  // Pass the playlist URL directly
                if (error) {
                    console.error('Error executing Python script:', stderr);
                    reject('Error fetching playlist');
                }

                try {
                    const result = JSON.parse(stdout);
                    if (result.error) {
                        reject(result.error);
                    } else {
                        resolve(result.songInfo); // Return song info
                    }
                } catch (parseError) {
                    reject('Error parsing response from Python script');
                }
            });
        });
    };

    try {
        // Fetch details for all playlists
        const allSongs = [];
        for (const url of randomizedUrls) {
            const songs = await fetchPlaylistDetails(url);
            allSongs.push(...songs); // Add all songs from this playlist
        }

        // Randomize the combined playlist
        const shuffledSongs = allSongs.sort(() => Math.random() - 0.5);

        // Return the randomized list of songs
        res.json({
            songCount: shuffledSongs.length,
            songInfo: shuffledSongs,
        });
    } catch (error) {
        console.error('Error processing playlists:', error);
        res.status(500).json({ error: 'Error fetching or processing playlists' });
    }
});

// Start the server on port 3000
app.listen(3000, () => console.log('Server running on http://192.168.0.154:3000'));
