const express = require('express');
const cors = require('cors');
const { execFile } = require('child_process');
const path = require('path');
const app = express();

// Enable CORS for all requests
app.use(cors());

// Route to get the audio
app.get('/get-audio', (req, res) => {
    const videoUrl = req.query.url;

    // Ensure videoUrl is present
    if (!videoUrl) {
        return res.status(400).json({ error: 'URL parameter is required' });
    }

    // Simple URL validation (you can expand this depending on your requirements)
    const urlPattern = /^(https?:\/\/)?(www\.)?(youtube|vimeo)\.com/;
    if (!urlPattern.test(videoUrl)) {
        return res.status(400).json({ error: 'Invalid video URL format' });
    }

    const pythonScript = path.join(__dirname, 'get_audio.py'); // Path to Python script

    // Use 'python3' for compatibility with some environments
    execFile('python3', [pythonScript, videoUrl], (error, stdout, stderr) => {
        if (error) {
            console.error('Error executing Python script:', stderr);
            return res.status(500).json({ error: 'Error fetching audio stream' });
        }

        // stdout should now contain valid JSON
        try {
            const result = JSON.parse(stdout);  // Parse the result from Python script

            // Check if there was an error in the result from Python script
            if (result.error) {
                console.error('Error in result:', result.error);
                return res.status(500).json({ error: result.error });
            }

            // Send the result (audio URL, title, and writer) as JSON
            res.json(result);

        } catch (parseError) {
            console.error('Error parsing JSON:', parseError);
            return res.status(500).json({ error: 'Error parsing response from Python script' });
        }
    });
});

// Start the server on port 3000
app.listen(3000, () => console.log('Server running on http://localhost:3000'));
