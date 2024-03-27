import 'package:flutter/material.dart';
import '../../../../models_api/movies_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../couleurs/couleurs.dart';
import '../../../../blocs/character_bloc.dart';
import '../../../../manager/api_manager.dart';

// Ce widget est conçu pour afficher un onglet dédié aux personnages d'un film spécifique.
class CharactersTab extends StatelessWidget {
  // Ce champ contient les informations du film dont les personnages seront affichés.
  final Movie movie;

  // Constructeur qui initialise le widget avec un film donné.
  const CharactersTab({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Création d'une instance de ApiManager, s'assurant qu'elle est correctement instanciée pour gérer les appels API.
    ApiManager apiManager = ApiManager();

    return BlocProvider<CharacterBloc>(
      // Fournit un bloc pour gérer l'état des personnages, initialisé et déclenchant la recherche par ID de film.
      create: (context) => CharacterBloc(apiManager)
        ..add(CharacterFetchByMovieIdEvent(movie.id)),
      child: BlocBuilder<CharacterBloc, CharacterState>(
        // Construit l'UI basée sur l'état courant du bloc des personnages.
        builder: (context, state) {
          if (state is CharacterLoadingState) {
            // Affiche un indicateur de progression pendant le chargement des données des personnages.
            return Center(
                child: CircularProgressIndicator(color: Colors.white));
          } else if (state is CharacterLoadedState) {
            // Une fois les données chargées, affiche les personnages dans une liste.
            return Container(
              color: AppColors
                  .seeMoreBackground, // Définit la couleur de fond du conteneur des personnages.
              child: ListView.builder(
                itemCount: state.characters
                    .length, // Nombre d'éléments basé sur les personnages chargés.
                itemBuilder: (context, index) {
                  // Construit un widget pour chaque personnage.
                  final character = state.characters[index];
                  return Card(
                    color: AppColors
                        .cardBackground, // Définit la couleur de fond de la carte de chaque personnage.
                    child: ListTile(
                      leading: CircleAvatar(
                        // Affiche l'image de profil du personnage.
                        backgroundImage:
                            NetworkImage(character.profileImageUrl),
                        backgroundColor: Colors.transparent,
                      ),
                      title: Text(
                        character.name, // Nom du personnage.
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is CharacterErrorState) {
            // En cas d'erreur lors du chargement, affiche un message d'erreur.
            return Center(
                child: Text('Erreur : ${state.error}',
                    style: TextStyle(color: Colors.white)));
          } else {
            // État initial avant le lancement de la recherche, invite à démarrer la recherche.
            return Center(
                child: Text('Commencez la recherche de personnages',
                    style: TextStyle(color: Colors.white)));
          }
        },
      ),
    );
  }
}
