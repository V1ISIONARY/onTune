class classification {
  final String musicTitle;
  final String musicWriter;
  final String audioUrl;

  classification({
    required this.musicTitle,
    required this.musicWriter,
    required this.audioUrl
  });

  factory classification.fromJson(Map<String, dynamic> json) {
    return classification(
      musicTitle: json['musicTitle'],
      musicWriter: json['musicWriter'],
      audioUrl: json['audioUrl'],
    );
  }

}