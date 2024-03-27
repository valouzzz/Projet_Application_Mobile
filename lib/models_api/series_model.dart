class Series {
  final int id;
  final String description;
  final String coverImageUrl;
  final String name;
  final int episodeCount;
  final String debutYear;
  final String detailEndpoint;

  Series({
    required this.id,
    this.description = 'Unknown',
    required this.coverImageUrl,
    required this.name,
    required this.episodeCount,
    this.debutYear = 'Unknown',
    required this.detailEndpoint,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      id: json['id'] as int? ?? 0,
      description: json['description'] as String? ?? 'Unknown',
      coverImageUrl: json['image']?['medium_url'] as String? ??
          'https://example.com/default_image.png', // Fournit une URL par défaut
      name: json['name'] as String? ?? 'Unknown',
      episodeCount: json['count_of_episodes'] as int? ?? 0,
      debutYear: json['start_year']?.toString() ??
          'Unknown', // Assure une conversion en String
      detailEndpoint: json['api_detail_url'] as String? ?? '',
    );
  }
}
