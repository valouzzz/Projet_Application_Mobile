import 'package:flutter/material.dart';
import '../../../models_api/series_model.dart';
import '../../series/series_ecran_details.dart';
import '../../../couleurs/couleurs.dart';

class SeriesWidget extends StatelessWidget {
  final Series series;
  final int rank; // Ajout pour gérer le rang de la série

  const SeriesWidget({
    super.key,
    required this.series,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final paddingSize = screenWidth * 0.02;
    final imageWidth = screenWidth * 0.25; // Taille réajustée pour l'image
    final imageHeight =
        imageWidth * 1.5; // Hauteur d'image plus grande pour un meilleur ratio
    final cardHeight = screenWidth *
        0.6 /
        2; // Hauteur de la carte ajustée pour afficher 4 éléments

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SeriesDetailsScreen(series: series),
          ),
        );
      },
      child: Container(
        height: cardHeight,
        margin: EdgeInsets.symmetric(
            horizontal: paddingSize, vertical: paddingSize / 2),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Numéro de rang
            Container(
              width: screenWidth * 0.08,
              height: cardHeight,
              decoration: BoxDecoration(
                color: AppColors.orange,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Center(
                child: Text(
                  '#$rank',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // Image de la série
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                series.coverImageUrl,
                width: imageWidth,
                height: imageHeight,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: paddingSize),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      series.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${series.episodeCount} épisodes', // Remplacer par le nombre réel d'épisodes
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                    Text(
                      series
                          .debutYear, // Remplacer par la date de sortie réelle
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
