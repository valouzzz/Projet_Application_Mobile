class Movie {
  final int id;
  final String title;
  final String coverImageUrl;
  final String synopsis;
  final String releaseDate;
  final String runningTime;
  final String productionBudget;
  final String grossRevenue;
  final String netRevenue;
  final String detailUrl;
  List<String> productionCompanies;
  List<String> screenplayAuthors;
  List<String> filmStudios;

  Movie({
    required this.id,
    required this.title,
    required this.coverImageUrl,
    this.synopsis = 'Unknown',
    required this.releaseDate,
    required this.runningTime,
    required this.productionBudget,
    required this.grossRevenue,
    required this.netRevenue,
    required this.detailUrl,
    required this.productionCompanies,
    required this.screenplayAuthors,
    required this.filmStudios,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: json['name'] as String? ?? 'Unknown',
      coverImageUrl: json['image']?['original_url'] as String? ??
          'https://example.com/default_image.png', // Fournit une URL par défaut si aucune image n'est disponible
      synopsis: json['deck'] as String? ??
          'Information not available', // Utilisation de 'deck' comme résumé
      releaseDate: json['release_date'] as String? ?? 'Unknown',
      runningTime: json['runtime'] as String? ?? 'Unknown',
      productionBudget: json['budget'] as String? ?? 'Unknown',
      grossRevenue: json['box_office_revenue'] as String? ?? 'Unknown',
      netRevenue: json['total_revenue'] as String? ?? 'Unknown',
      detailUrl: json['api_detail_url'] as String? ?? '',
      productionCompanies: List<String>.from(
          json['producers']?.map((producer) => producer['name']) ?? []),
      screenplayAuthors: List<String>.from(
          json['writers']?.map((writer) => writer['name']) ?? []),
      filmStudios: List<String>.from(
          json['studios']?.map((studio) => studio['name']) ?? []),
    );
  }
}
