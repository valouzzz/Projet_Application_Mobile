class News {
  final String headline;
  final String coverImageUrl;
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
