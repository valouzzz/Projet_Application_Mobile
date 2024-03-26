import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/movies_bloc.dart';
import '../widgets/movies.dart';
import '../couleurs/couleurs.dart';

class MoviesListScreen extends StatelessWidget {
  const MoviesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MoviesBloc>(context).add(MovieFetchEvent());

    return Scaffold(
      appBar: AppBar(
          title: const Text('Films les plus populaires',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF0F1921)),
      body: BlocBuilder<MoviesBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieLoadedState) {
            return ListView.separated(
              itemCount: state.movies.length,
              separatorBuilder: (context, index) => Divider(
                  color: AppColors.seeMoreBackground), // Diviseur personnalisé
              itemBuilder: (context, index) {
                final movie = state.movies[index];
                return MoviesWidget(
                  movie: movie,
                  rank: index + 1, // Passer le rang pour afficher le numéro
                );
              },
            );
          } else if (state is MovieErrorState) {
            return Center(
              child: Text('Erreur: ${state.error}'),
            );
          } else {
            return const Center(
                child:
                    Text('Aucune donnée. Swipez vers le bas pour rafraîchir.'));
          }
        },
      ),
      backgroundColor:
          AppColors.seeMoreBackground, // Mettez la couleur de fond ici
    );
  }
}
