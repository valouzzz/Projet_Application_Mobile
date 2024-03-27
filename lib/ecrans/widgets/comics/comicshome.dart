import 'package:flutter/material.dart';
import '../../../models_api/comics_model.dart'; // Import du modèle de données pour les bandes dessinées.
import '../../comics/comics_ecran_details.dart';
import '../../../couleurs/couleurs.dart';

// Widget pour afficher une carte de bande dessinée dans l'écran d'accueil.
class ComicsHomeWidget extends StatelessWidget {
  final Comic
      comic; // Instance de Comic contenant les détails de la bande dessinée.

  // Constructeur qui initialise le widget avec une bande dessinée spécifique.
  const ComicsHomeWidget({super.key, required this.comic});

  @override
  Widget build(BuildContext context) {
    // Calcul de dimensions basées sur la largeur de l'écran.
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenWidth *
        0.3; // Hauteur de l'image de couverture basée sur la largeur de l'écran.
    final cardHeight = screenWidth * 0.5; // Hauteur totale de la carte.

    return GestureDetector(
      onTap: () {
        // Navigue vers l'écran de détails de la bande dessinée au tap.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ComicsDetailsScreen(comics: comic),
          ),
        );
      },
      child: Container(
        width: screenWidth *
            0.4, // Largeur de la carte fixée à 40% de la largeur de l'écran.
        height: cardHeight,
        margin: EdgeInsets.symmetric(
            horizontal: 10, vertical: 5), // Marges autour de la carte.
        decoration: BoxDecoration(
          color: AppColors.elementBackground, // Couleur de fond de la carte.
          borderRadius: BorderRadius.circular(10), // Bordures arrondies.
          boxShadow: [
            // Ombre portée pour un effet de profondeur.
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10)), // Arrondit le haut de l'image.
              child: Image.network(
                comic
                    .coverImageUrl, // URL de l'image de couverture de la bande dessinée.
                width: double
                    .infinity, // L'image occupe toute la largeur disponible.
                height: imageHeight,
                fit: BoxFit
                    .cover, // L'image couvre l'espace alloué sans perdre ses proportions.
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(
                    8), // Padding à l'intérieur de la partie texte.
                child: Center(
                  child: Text(
                    comic.title, // Titre de la bande dessinée.
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize:
                          14, // Taille de la police ajustée pour la lisibilité.
                    ),
                    textAlign:
                        TextAlign.center, // Centre le texte horizontalement.
                    overflow: TextOverflow
                        .ellipsis, // Gère les titres longs avec des points de suspension.
                    maxLines:
                        2, // Permet au titre de s'étendre sur deux lignes au maximum.
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
