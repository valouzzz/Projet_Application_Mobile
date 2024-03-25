import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/character_model.dart';
import '../services/api_manager.dart'; // Adaptation pour la cohérence de nommage

// Définition des types d'événements gérés par le bloc Character
abstract class CharacterEvent extends Equatable {
  const CharacterEvent();
}

// Événement pour initier la récupération de tous les personnages
class CharacterFetchAllEvent extends CharacterEvent {
  @override
  List<Object> get props => [];
}

// Événement pour initier la récupération des personnages par ID de film
class CharacterFetchByMovieIdEvent extends CharacterEvent {
  final int movieId;

  const CharacterFetchByMovieIdEvent(this.movieId);

  @override
  List<Object> get props => [movieId];
}

// Définition des états possibles du bloc Character
abstract class CharacterState extends Equatable {
  const CharacterState();
}

// État initial du bloc, aucun personnage n'est encore chargé
class CharacterInitialState extends CharacterState {
  @override
  List<Object> get props => [];
}

// État de chargement, indique une opération de récupération en cours
class CharacterLoadingState extends CharacterState {
  @override
  List<Object> get props => [];
}

// État de succès, indique que les personnages ont été chargés avec succès
class CharacterLoadedState extends CharacterState {
  final List<Character>
      characters; // Utilisation de CharacterDetails pour la clarté

  const CharacterLoadedState(this.characters);

  @override
  List<Object> get props => [characters];
}

// État d'erreur, indique une erreur survenue lors de la récupération des personnages
class CharacterErrorState extends CharacterState {
  final String message; // Renommé pour une meilleure clarté

  const CharacterErrorState(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc pour la gestion des personnages, répondant aux événements et mettant à jour l'état
class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final ApiManager apiManager; // Adaptation pour la cohérence avec ApiManager

  CharacterBloc(this.apiManager) : super(CharacterInitialState()) {
    // Réaction à l'événement de récupération de tous les personnages
    on<CharacterFetchAllEvent>((event, emit) async {
      emit(CharacterLoadingState());
      try {
        final characters = await apiManager.fetchCharacters();
        emit(CharacterLoadedState(characters));
      } catch (e) {
        emit(CharacterErrorState('Failed to fetch characters: $e'));
      }
    });

    // Réaction à l'événement de récupération des personnages par ID de film
    on<CharacterFetchByMovieIdEvent>((event, emit) async {
      emit(CharacterLoadingState());
      try {
        final characters =
            await apiManager.fetchCharactersByMoviesId(event.movieId);
        emit(CharacterLoadedState(characters));
      } catch (e) {
        emit(CharacterErrorState(
            'Failed to fetch characters for movie ${event.movieId}: $e'));
      }
    });
  }
}
