class Lyrics {
  final String? title;
  final String? writer;
  final String lyrics;

  Lyrics({this.title, this.writer, required this.lyrics});

  factory Lyrics.fromJson(Map<String, dynamic> json) {
    return Lyrics(
      title: json['title'],
      writer: json['writer'],
      lyrics: json['lyrics'],
    );
  }
}
