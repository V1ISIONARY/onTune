class Lyrics {
  final String lyrics;

  Lyrics({required this.lyrics});

  factory Lyrics.fromJson(Map<String, dynamic> json) {
    return Lyrics(
      lyrics: json['lyrics'] ?? 'Unknown Lyrics',
    );
  }

}
