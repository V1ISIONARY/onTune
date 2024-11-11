import sys
import yt_dlp
import json
import re
import requests
from bs4 import BeautifulSoup

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

def get_lyrics_from_genius(writer, title):
    """Fetch lyrics from Genius based on song title and artist."""
    # Replace spaces with dashes in both writer and title
    writer = writer.replace(" ", "-").capitalize()  # Capitalize the first letter of the writer
    title = title.replace(" ", "-")  # Replace spaces with dashes in the title

    # Format the search URL for Genius
    search_url = f"https://genius.com/{writer}-{title}-lyrics"

    try:
        # Request the song page
        response = requests.get(search_url)
        response.raise_for_status()  # This will raise an exception for 404 or other HTTP errors
        
        # Parse the HTML content
        soup = BeautifulSoup(response.text, 'html.parser')
        
        # Find the lyrics container using the class name
        lyrics_div = soup.find('div', class_='Lyrics__Container-sc-1ynbvzw-1 kUgSbL')
        if lyrics_div:
            # Get the raw HTML of the lyrics container
            lyrics = str(lyrics_div)
            
            # Remove all HTML tags using BeautifulSoup's get_text method
            lyrics = BeautifulSoup(lyrics, 'html.parser').get_text("\n", strip=True)

            # Replace <br> tags with newlines manually (in case get_text does not handle it)
            lyrics = lyrics.replace('<br>', '\n')

            # Remove text inside square brackets and the brackets themselves
            lyrics = re.sub(r'\[.*?\]', '', lyrics)
            
            # Add a newline after each quotation mark
            lyrics = lyrics.replace('"', '"\n')

            return lyrics
        else:
            return 'Lyrics not found in the expected location.'
    except requests.exceptions.HTTPError as http_err:
        # Handle HTTP errors like 404
        if response.status_code == 404:
            return f"Lyrics not found for {writer} - {title} (404 Error)"
        return f"HTTP error occurred: {http_err}"
    except Exception as e:
        return f"Error fetching lyrics: {str(e)}"

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

            # Fetch the lyrics from Genius
            lyrics = get_lyrics_from_genius(writer, title)

            if audio_url:
                return json.dumps({
                    'audioUrl': audio_url,
                    'title': title,  # Cleaned title with spaces
                    'writer': writer,  # Cleaned writer
                    'lyrics': lyrics  # Include lyrics in the result
                })
            else:
                return json.dumps({'error': 'Audio URL not found'})
        except Exception as e:
            return json.dumps({'error': str(e)})

if __name__ == "__main__":
    video_url = sys.argv[1]  # Get the video URL from the command line
    result = download_audio(video_url)
    print(result)  # Output the result as JSON
