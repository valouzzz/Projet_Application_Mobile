import 'package:flutter/material.dart';
import '../models/movies_model.dart'; // Remplacez par le chemin d'accès correct à votre modèle de film
import '../screens/movies_details_screen.dart'; // Remplacez par le chemin d'accès correct à votre écran de détails de film

class MovieHomeWidget extends StatelessWidget {
  final Movie
      movie; // Assurez-vous que 'Movie' est la classe correcte de votre modèle

  const MovieHomeWidget({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenWidth * 0.3;
    final cardHeight = screenWidth * 0.5;

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
        width: screenWidth * 0.4,
        height: cardHeight,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .secondary, // ou une couleur spécifique si vous l'avez définie
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                movie
                    .coverImageUrl, // Assurez-vous que 'imageUrl' est un champ valide de votre modèle 'Movie'
                width: double.infinity,
                height: imageHeight,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    movie
                        .title, // Assurez-vous que 'title' est un champ valide de votre modèle 'Movie'
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
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
