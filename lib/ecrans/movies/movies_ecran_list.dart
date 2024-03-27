import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/movies_bloc.dart';
import '../widgets/movies/movies.dart';
import '../../couleurs/couleurs.dart';

// Écran affichant une liste des films les plus populaires.
class MoviesListScreen extends StatelessWidget {
  const MoviesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Déclenche l'événement pour charger la liste des films dès que l'écran est construit.
    BlocProvider.of<MoviesBloc>(context).add(MovieFetchEvent());

    return Scaffold(
      appBar: AppBar(
          title: const Text('Films les plus populaires',
              style: TextStyle(color: Colors.white)), // Titre de l'appBar.
          backgroundColor: Color(0xFF0F1921)), // Couleur de fond de l'appBar.
      body: BlocBuilder<MoviesBloc, MovieState>(
        builder: (context, state) {
          // Gère les différents états de chargement des films.
          if (state is MovieLoadingState) {
            // Affiche un indicateur de chargement pendant la récupération des données.
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieLoadedState) {
            // Affiche la liste des films une fois chargés.
            return ListView.separated(
              itemCount:
                  state.movies.length, // Nombre d'éléments dans la liste.
              separatorBuilder: (context, index) => Divider(
                  color: AppColors
                      .seeMoreBackground), // Diviseur personnalisé entre les éléments de la liste.
              itemBuilder: (context, index) {
                // Construit un widget pour chaque film dans la liste.
                final movie = state.movies[index];
                return MoviesWidget(
                  movie: movie,
                  rankMovie: index +
                      1, // Passe le rang du film pour afficher le numéro.
                );
              },
            );
          } else if (state is MovieErrorState) {
            // Affiche un message d'erreur si le chargement des films échoue.
            return Center(
              child: Text('Erreur: ${state.error}'),
            );
          } else {
            // Affiche un message par défaut si aucun état n'est rencontré ou si la liste est vide.
            return const Center(child: Text('Aucune donnée.'));
          }
        },
      ),
      backgroundColor:
          AppColors.seeMoreBackground, // Couleur de fond de l'écran.
    );
  }
}
