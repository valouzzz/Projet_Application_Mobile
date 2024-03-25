class Episode {
  final int id; // Utilisé pour identifier de manière unique chaque épisode
  final String title; // 'name' renommé en 'title' pour une meilleure clarté
  final String
      synopsis; // 'description' devient 'synopsis' pour une meilleure distinction
  final String
      thumbnailUrl; // 'imageUrl' renommé et modifié pour refléter qu'il s'agit d'une miniature
  final String broadcastDate; // 'airDate' renommé pour une meilleure clarté
  final String number; // 'episodeNumber' renommé en 'number' pour simplifier

  Episode({
    required this.id,
    required this.title,
    this.synopsis = 'Unknown',
    required this.thumbnailUrl,
    required this.broadcastDate,
    required this.number,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] as int? ??
          0, // Assurer que l'ID est un int, avec 0 comme valeur par défaut
      title: json['name'] as String? ?? 'Unknown Episode',
      synopsis: json['description'] as String? ?? 'No synopsis available',
      thumbnailUrl: json['image']?['icon_url'] as String? ??
          'https://example.com/default_episode_thumbnail.png', // Fournir une URL par défaut pour la miniature
      broadcastDate: json['air_date'] as String? ?? 'Unknown Date',
      number: json['episode_number'] as String? ??
          'N/A', // Fournir 'N/A' comme valeur par défaut si non spécifié
    );
  }
}
