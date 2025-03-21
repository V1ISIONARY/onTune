class SongModel {
  final String musicTitle;
  final String artistName;
  final String spotifyUrlAudioLink;
  final String audioUrl;
  final String thumbnail;
  final String playlistUrl;
  final String subscribers;
  final String writerLogo;

  SongModel({
    required this.musicTitle,
    required this.artistName,
    required this.spotifyUrlAudioLink,
    required this.audioUrl,
    required this.thumbnail,
    required this.playlistUrl,
    required this.subscribers,
    required this.writerLogo,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      musicTitle: json['musicTitle'] ?? 'Unknown Title',
      artistName: json['artistName'] ?? 'Unknown Artist',
      spotifyUrlAudioLink: json['spotifyUrlAudioLink'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      playlistUrl: json['playlistUrl'] ?? '',
      subscribers: json['subscribers'] ?? '',
      writerLogo: json['writerLogo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'musicTitle': musicTitle,
      'artistName': artistName,
      'spotifyUrlAudioLink': spotifyUrlAudioLink,
      'audioUrl': audioUrl,
      'thumbnail': thumbnail,
      'playlistUrl': playlistUrl,
      'subscribers': subscribers,
      'writerLogo': writerLogo,
    };
  }
}
