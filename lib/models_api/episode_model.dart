class Episode {
  final int id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String broadcastDate;
  final String number;

  Episode({
    required this.id,
    required this.title,
    this.description = 'Unknown',
    required this.thumbnailUrl,
    required this.broadcastDate,
    required this.number,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] as int? ??
          0, // Assurer que l'ID est un int, avec 0 comme valeur par défaut
      title: json['name'] as String? ?? 'Unknown Episode',
      description: json['description'] as String? ?? 'No synopsis available',
      thumbnailUrl: json['image']?['icon_url'] as String? ??
          'https://example.com/default_episode_thumbnail.png', // Fournir une URL par défaut pour la miniature
      broadcastDate: json['air_date'] as String? ?? 'Unknown Date',
      number: json['episode_number'] as String? ??
          'N/A', // Fournir 'N/A' comme valeur par défaut si non spécifié
    );
  }
}
