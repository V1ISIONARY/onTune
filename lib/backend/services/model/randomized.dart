class Randomized {
  
  final String musicTitle;
  final String musicWriter;
  final String audioUrl;
  final String thumnail;

  Randomized({
    required this.musicTitle,
    required this.musicWriter,
    required this.audioUrl,
    required this.thumnail
  });

  factory Randomized.fromJson(Map<String, dynamic> json) {
    return Randomized(
      musicTitle: json['title'] ?? 'Unknown Title',  // Provide default value if title is null
      musicWriter: json['writer'] ?? 'Unknown Writer',
      audioUrl: json['url'] ?? 'No URL Available',   // Provide default value if url is null
      thumnail: json['image_url'] ?? 'No Url Available'
    );
  }

}