class Randomized {
  
  final String musicTitle;
  final String musicWriter;
  final String audioUrl;
  final String thumnail;
  final String playlistUrl;
  final String subscribers;
  final String writerLogo;

  Randomized({
    required this.musicTitle,
    required this.musicWriter,
    required this.audioUrl,
    required this.thumnail,
    required this.playlistUrl,
    required this.subscribers,
    required this.writerLogo
  });

  factory Randomized.fromJson(Map<String, dynamic> json) {
    return Randomized(
      musicTitle: json['title'] ?? 'Unknown Title', 
      musicWriter: json['writer'] ?? 'Unknown Writer',
      audioUrl: json['url'] ?? 'No URL Available',  
      thumnail: json['image_url'] ?? 'No Url Available',
      playlistUrl: json['playlistUrl'] ?? 'Unknown Url',
      subscribers: json['subscribers'] ?? 'N/A',
      writerLogo: json['writerLogo'] ?? 'N/A'
    );
  }

}