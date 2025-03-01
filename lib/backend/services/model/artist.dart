class Artist {
  final String name;
  final String description;

  Artist({required this.name, required this.description});

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      name: json['artist'] ?? 'Unknown Artist',
      description: json['description'] ?? 'No description available',
    );
  }

}
