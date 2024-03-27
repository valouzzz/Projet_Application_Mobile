import 'package:flutter/material.dart';
import '../../../models_api/comics_model.dart';
import '../../comics/comics_ecran_details.dart';
import '../../../couleurs/couleurs.dart';

// Widget représentant une carte d'aperçu pour une bande dessinée.
class ComicsWidget extends StatelessWidget {
  final Comic
      comic; // Instance de Comic contenant les détails de la bande dessinée.

  // Constructeur de ComicsWidget qui nécessite une instance de Comic.
  const ComicsWidget({super.key, required this.comic});

  @override
  Widget build(BuildContext context) {
    // Calcule les dimensions de la carte en fonction de la largeur de l'écran.
    final screenWidth = MediaQuery.of(context).size.width;
    final paddingSize = screenWidth * 0.02; // Espace autour de la carte.
    final imageWidth = screenWidth * 0.25; // Largeur de l'image de couverture.
    final imageHeight =
        imageWidth * 1.5; // Hauteur de l'image pour un ratio 3:2.
    final cardHeight = screenWidth *
        0.6 /
        2; // Hauteur de la carte pour afficher 4 éléments dans la vue.

    return GestureDetector(
      onTap: () {
        // Navigue vers l'écran de détails de la bande dessinée lorsque l'utilisateur touche la carte.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ComicsDetailsScreen(comics: comic),
          ),
        );
      },
      child: Container(
        height: cardHeight,
        margin: EdgeInsets.symmetric(
            horizontal: paddingSize, vertical: paddingSize / 2),
        decoration: BoxDecoration(
          color: AppColors.cardBackground, // Couleur de fond de la carte.
          borderRadius:
              BorderRadius.circular(8), // Arrondit les coins de la carte.
          boxShadow: [
            // Ajoute une ombre pour un effet 3D.
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Affiche l'image de couverture de la bande dessinée.
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                comic.coverImageUrl,
                width: imageWidth,
                height: imageHeight,
                fit: BoxFit.cover,
              ),
            ),
            // Conteneur pour le titre et les informations supplémentaires.
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: paddingSize),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Affiche le titre de la bande dessinée.
                    Text(
                      comic.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow
                          .ellipsis, // Gère les titres longs avec des ellipses.
                    ),
                    SizedBox(height: 4), // Espace entre les lignes de texte.
                    // Affiche la date de parution.
                    Text(
                      'Parution: ${comic.publicationDate}',
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                    SizedBox(height: 4), // Espace entre les lignes de texte.
                    // Affiche le numéro de volume.
                    Text(
                      'Volume: ${comic.issueNumber}',
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
