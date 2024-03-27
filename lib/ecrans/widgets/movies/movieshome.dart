import 'package:flutter/material.dart';
import '../../../models_api/movies_model.dart'; // Import du modèle de données pour les films.
import '../../movies/movies_ecran_details.dart'; // Import de l'écran affichant les détails d'un film.

// Widget affichant un film dans la vue principale avec une interaction au toucher.
class MovieHomeWidget extends StatelessWidget {
  final Movie
      movie; // Instance de la classe Movie contenant les détails du film.

  // Constructeur nécessitant une instance de Movie.
  const MovieHomeWidget({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calcul des dimensions pour l'affichage basé sur la largeur de l'écran.
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenWidth * 0.3; // Hauteur de l'image de couverture.
    final cardHeight = screenWidth * 0.5; // Hauteur totale de la carte.

    return GestureDetector(
      onTap: () {
        // Navigue vers l'écran de détails du film au toucher.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MoviesDetailsScreen(movies: movie),
          ),
        );
      },
      child: Container(
        width: screenWidth *
            0.4, // Largeur de la carte fixée à 40% de la largeur de l'écran.
        height: cardHeight,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .secondary, // Utilise la couleur secondaire du thème, ou spécifiez une couleur personnalisée.
          borderRadius: BorderRadius.circular(
              10), // Bords arrondis pour un style élégant.
          boxShadow: const [
            BoxShadow(
              color:
                  Colors.black12, // Ombre légère pour un effet de profondeur.
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Affiche l'image de couverture du film.
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                movie
                    .coverImageUrl, // Assurez-vous que 'coverImageUrl' correspond à un champ de l'instance de Movie.
                width: double.infinity,
                height: imageHeight,
                fit: BoxFit
                    .cover, // Remplit l'espace tout en préservant le ratio de l'image.
              ),
            ),
            // Conteneur pour le titre du film.
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    movie
                        .title, // Le titre du film, s'assurer que 'title' est bien un champ de Movie.
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow
                        .ellipsis, // Gère les titres longs avec une fin ellipsée.
                    maxLines:
                        2, // Limite le titre à 2 lignes pour éviter les débordements.
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
