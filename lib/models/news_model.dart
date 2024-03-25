class News {
  final String
      headline; // 'title' renommé en 'headline' pour une distinction claire
  final String
      coverImageUrl; // 'imageUrl' renommé pour spécifier qu'il s'agit de l'image de couverture de l'article

  News({
    required this.headline,
    required this.coverImageUrl,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      headline: json['title'] as String? ?? 'Unknown Title',
      coverImageUrl: json['image']?['original'] as String? ??
          'https://example.com/default_news_image.png', // Fournir une URL d'image par défaut
    );
  }
}
