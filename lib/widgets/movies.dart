import 'package:flutter/material.dart';
import '../models/movies_model.dart';
import '../screens/movies_details_screen.dart';
import '../couleurs/couleurs.dart';

class MoviesWidget extends StatelessWidget {
  final Movie movie;
  final int rank; // Ajout pour gérer le rang du film

  const MoviesWidget({
    super.key,
    required this.movie,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageWidth = screenWidth * 0.25; // Taille ajustée pour l'image
    final imageHeight =
        imageWidth * 1.5; // Hauteur d'image pour un meilleur ratio
    final cardHeight = screenWidth *
        0.6 /
        2; // Hauteur de la carte ajustée pour afficher 4 éléments

    String yearOfRelease = 'Information inconnue';
    if (movie.releaseDate != 'Information inconnue') {
      try {
        DateTime releaseDate = DateTime.parse(movie.releaseDate);
        yearOfRelease = releaseDate.year.toString();
      } catch (e) {
        debugPrint('Error parsing release date: $e');
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MoviesDetailsScreen(movies: movie),
          ),
        );
      },
      child: Container(
        height: cardHeight,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Numéro de rang
            Container(
              width: screenWidth * 0.08,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.orange,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Text(
                '#$rank',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            // Image de couverture
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                movie.coverImageUrl,
                width: imageWidth,
                height: imageHeight,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      movie.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Informations supplémentaires
                    Text(
                      '${movie.runningTime} min', // Remplacer par le nombre réel d'épisodes
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                    Text(
                      yearOfRelease, // Remplacer par la date de sortie réelle
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
