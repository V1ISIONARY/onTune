import sys
import yt_dlp
import json

def get_playlist_info(playlist_url):
    
    ydl_opts = {
        'quiet': True,  # Suppress all logs
        'extract_flat': True,  # Only extract playlist info (without downloading)
    }

    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        try:
            # Extract playlist info
            playlist_info = ydl.extract_info(playlist_url, download=False)

            if 'entries' in playlist_info:
                
                # Extract the URLs (href) of the songs in the playlist
                song_info = [
                    {
                    'title': entry['title'], 
                    'writer': entry.get('uploader') or entry.get('artist') or entry.get('creator', 'Unknown'),
                    'url': entry['url'],
                    'image_url': entry.get('thumbnails', [{}])[-1].get('url', '')  # Get the highest resolution image URL
                    } for entry in playlist_info['entries']
                ]
                song_count = len(song_info)  # Total count of songs
                
                return json.dumps({
                    'songCount': song_count, 
                    'songInfo': song_info
                })
                
            else:
                return json.dumps({'error': 'No entries found in the playlist'})
        except Exception as e:
            return json.dumps({'error': str(e)})

if __name__ == "__main__":
    playlist_url = sys.argv[1]  # Get the playlist URL from command-line arguments
    result = get_playlist_info(playlist_url)
    print(result)  # Output the result as JSON
