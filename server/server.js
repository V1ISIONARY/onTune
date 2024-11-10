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
    const videoUrl = req.query.url;

    if (!videoUrl) {
        return res.status(400).json({ error: 'URL parameter is required' });
    }

    const youtubeUrl = convertMusicUrlToYouTubeUrl(videoUrl);

    console.log("Final YouTube URL to process:", youtubeUrl);

    const urlPattern = /^(https?:\/\/)?(www\.)?(youtube|music\.youtube)\.com/;
    if (!urlPattern.test(youtubeUrl)) {
        console.error("Invalid URL format:", youtubeUrl);
        return res.status(400).json({ error: 'Invalid video URL format' });
    }

    const pythonScript = path.join(__dirname, 'get_audio.py');

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

// Start the server on port 3000
app.listen(3000, () => console.log('Server running on http://192.168.0.154:3000'));
