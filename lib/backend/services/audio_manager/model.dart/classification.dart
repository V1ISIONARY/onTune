class Classification {
  
  final String musicTitle;
  final String musicWriter;
  final String audioUrl;
  final String lyrics;

  Classification({
    required this.musicTitle,
    required this.musicWriter,
    required this.audioUrl,
    required this.lyrics
  });

  factory Classification.fromJson(Map<String, dynamic> json) {
    return Classification(
      musicTitle: json['musicTitle'],
      musicWriter: json['musicWriter'],
      audioUrl: json['audioUrl'],
      lyrics: json['lyrics']
    );
  }

}