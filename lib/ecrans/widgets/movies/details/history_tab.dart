import 'package:flutter/material.dart';
import '../../../../models_api/movies_model.dart';
import '../../../../couleurs/couleurs.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

// Widget affichant l'historique ou le synopsis d'un film donné.
class HistoryTab extends StatelessWidget {
  final Movie movie; // Contient les détails du film, notamment le synopsis.

  // Constructeur de HistoryTab prenant un film spécifique comme argument.
  const HistoryTab({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Conteneur pour l'affichage du synopsis avec une couleur de fond personnalisée.
    return Container(
      color: AppColors
          .seeMoreBackground, // Définit la couleur de fond pour le contenu du synopsis.
      child: SingleChildScrollView(
        // Utilise un SingleChildScrollView pour permettre le défilement si le contenu dépasse la vue.
        padding: const EdgeInsets.all(8.0),
        child: HtmlWidget(
          movie.synopsis, // Affiche le synopsis du film formaté en HTML.
          textStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
              color: Colors
                  .white), // Adapte le style du texte au thème général avec la couleur blanche.
        ),
      ),
    );
  }
}
