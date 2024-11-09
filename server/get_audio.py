import sys
import yt_dlp
import json
import re

def remove_parentheses(text):
    """Removes any text within parentheses from a string."""
    return re.sub(r'\s*\(.*?\)\s*', '', text).strip()

def remove_symbols(text):
    """Removes most symbols, retaining only alphanumeric characters and spaces."""
    return re.sub(r'[^A-Za-z0-9 ]', '', text).strip()

def remove_text_before_dash(text):
    """Removes any text before the first dash, including the dash, and removes any space after the dash."""
    return text.split("-", 1)[-1].lstrip() if "-" in text else text

def remove_writer_from_title(title, writer):
    """Removes the writer's name from the title if it appears within it."""
    writer_escaped = re.escape(writer)
    return re.sub(r'\b' + writer_escaped + r'\b', '', title).strip()

def download_audio(video_url):
    ydl_opts = {
        'format': 'bestaudio/best',  # Choose the best audio format available
        'outtmpl': '/tmp/audio.%(ext)s',  # Output path
        'quiet': True,  # Suppress all logs (including progress bars)
    }

    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        try:
            # Fetch video info without downloading
            info_dict = ydl.extract_info(video_url, download=False)
            audio_url = info_dict.get("url", None)
            
            # Clean title and writer
            title = remove_parentheses(info_dict.get("title", "Unknown Title"))
            writer = remove_parentheses(info_dict.get("artist", info_dict.get("uploader", "Unknown Writer")))

            # Remove text before dash, writer's name, and symbols (except spaces) from title
            title = remove_text_before_dash(title)
            title = remove_writer_from_title(title, writer)
            title = remove_symbols(title)

            if audio_url:
                return json.dumps({
                    'audioUrl': audio_url,
                    'title': title,  # Cleaned title with spaces
                    'writer': writer  # Cleaned writer
                })
            else:
                return json.dumps({'error': 'Audio URL not found'})
        except Exception as e:
            return json.dumps({'error': str(e)})

if __name__ == "__main__":
    video_url = sys.argv[1]  # Get the video URL from the command line
    result = download_audio(video_url)
    print(result)  # Output the result as JSON
