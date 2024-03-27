class Comic {
  final int id;
  final String title;
  final String coverImageUrl;
  final String summary;
  final String publicationDate;
  final String issueNumber;
  final String detailUrl;
  final String volumeTitle;
  final int volumeId;

  Comic({
    required this.id,
    required this.title,
    required this.coverImageUrl,
    this.summary = 'Unknown',
    required this.publicationDate,
    required this.issueNumber,
    required this.detailUrl,
    required this.volumeTitle,
    required this.volumeId,
  });

  factory Comic.fromJson(Map<String, dynamic> json) {
    return Comic(
      id: json['id'] as int? ?? 0,
      title: json['name'] as String? ?? 'Unknown',
      coverImageUrl: json['image']?['medium_url'] as String? ??
          'https://example.com/default_comic_cover.png', // URL par défaut
      summary: json['description'] as String? ?? 'No summary available',
      publicationDate: json['cover_date'] as String? ?? 'Unknown',
      issueNumber: json['issue_number'] as String? ?? 'Unknown',
      detailUrl: json['api_detail_url'] as String? ?? '',
      volumeTitle: json['volume']?['name'] as String? ?? 'Unknown Volume',
      volumeId: json['volume']?['id'] as int? ?? 0,
    );
  }
}
