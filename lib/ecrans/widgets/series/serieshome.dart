import 'package:flutter/material.dart';
import '../../../couleurs/couleurs.dart';
import '../../../models_api/series_model.dart';
import '../../series/series_ecran_details.dart';

class SeriesHomeWidget extends StatelessWidget {
  final Series series; // Modifier pour passer l'objet Series

  const SeriesHomeWidget({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenWidth * 0.3; // hauteur de l'image
    final cardHeight =
        screenWidth * 0.5; // hauteur totale de la carte, ajustez au besoin

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
        width: screenWidth * 0.4, // largeur du widget
        height: cardHeight,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.elementBackground, // Couleur de fond pour le widget
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
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
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                series.coverImageUrl,
                width: double
                    .infinity, // force l'image à remplir la largeur du conteneur
                height: imageHeight,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    series.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14, // ajuster la taille de la police au besoin
                    ),
                    textAlign: TextAlign.center,
                    overflow:
                        TextOverflow.ellipsis, // gère les textes plus longs
                    maxLines: 2, // permet au texte de s'étendre sur deux lignes
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
