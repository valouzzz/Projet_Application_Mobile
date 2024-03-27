class Character {
  final String name;
  final String profileImageUrl;
  final String bio;
  final String alias;
  final int genderCode;
  final String? birthDate;

  Character({
    required this.name,
    required this.profileImageUrl,
    this.bio = 'Unknown',
    this.alias = 'Unknown',
    this.genderCode =
        0, // Utiliser 0 comme valeur par défaut indiquant 'non spécifié'
    this.birthDate,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'] as String? ?? 'Unknown',
      profileImageUrl: json['image']?['medium_url'] as String? ??
          'https://example.com/default_character.png', // URL par défaut pour les images
      bio: json['description'] as String? ?? 'No biography available',
      alias: json['real_name'] as String? ?? 'Unknown',
      genderCode: json['gender'] as int? ??
          0, // Assurez-vous d'utiliser un entier comme valeur par défaut
      birthDate: json['birth'] as String?,
    );
  }
}
