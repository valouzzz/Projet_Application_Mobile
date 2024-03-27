import 'package:flutter/material.dart';
import '../../../../models_api/movies_model.dart';
import '../../../../couleurs/couleurs.dart';

// Widget affichant un onglet d'informations détaillées sur un film.
class InfosTab extends StatelessWidget {
  final Movie
      movie; // Instance de la classe Movie contenant les informations sur le film.

  // Constructeur nécessitant une instance de Movie.
  const InfosTab({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Container principal pour les informations du film, avec un fond défini.
    return Container(
      color: AppColors
          .seeMoreBackground, // Définit la couleur de fond de l'onglet d'infos.
      child: ListView(
        // Liste déroulante des informations du film.
        children: [
          _buildInfoItem(
              'Duration',
              movie.runningTime.toString() +
                  ' min'), // Affiche la durée du film.
          _buildInfoItem(
              'Release Date', movie.releaseDate), // Affiche la date de sortie.
          _buildInfoItem(
              'Budget',
              '\$' +
                  movie.productionBudget
                      .toString()), // Affiche le budget de production.
          _buildInfoItem(
              'Box Office Revenue',
              '\$' +
                  movie.grossRevenue
                      .toString()), // Affiche les revenus au box-office.
          _buildInfoItem(
              'Total Revenue',
              '\$' +
                  movie.netRevenue.toString()), // Affiche les revenus totaux.
          _buildInfoItem(
              'Producers',
              _formatListToString(movie
                  .productionCompanies)), // Liste des sociétés de production.
          _buildInfoItem(
              'Writers',
              _formatListToString(
                  movie.screenplayAuthors)), // Liste des auteurs du scénario.
          _buildInfoItem(
              'Studios',
              _formatListToString(
                  movie.filmStudios)), // Liste des studios de film.
        ],
      ),
    );
  }

  // Construit un élément d'information avec un titre et une valeur.
  Widget _buildInfoItem(String title, String value) {
    return ListTile(
      title: Text(title,
          style: TextStyle(
              color: Colors.white)), // Titre de l'information en blanc.
      subtitle: Text(value,
          style: TextStyle(
              color: Colors.grey)), // Valeur de l'information en gris.
    );
  }

  // Convertit une liste de chaînes en une seule chaîne séparée par des virgules.
  String _formatListToString(List<String> list) {
    return list.join(
        ', '); // Joint les éléments de la liste avec une virgule et un espace.
  }
}

// Fonction pour construire une carte d'information, non utilisée dans InfosTab mais potentiellement utile ailleurs.
Widget _buildCardItem({
  required String imageUrl,
  required String title,
  String? subtitle,
  required BuildContext context,
}) {
  return Card(
    color: AppColors.cardBackground, // Définit la couleur de fond de la carte.
    child: ListTile(
      leading: Image.network(imageUrl, fit: BoxFit.cover), // Image de la carte.
      title: Text(title,
          style: TextStyle(color: Colors.white)), // Titre de la carte en blanc.
      subtitle: subtitle != null
          ? Text(subtitle,
              style: TextStyle(
                  color:
                      Colors.white70)) // Sous-titre de la carte si disponible.
          : null,
    ),
  );
}
