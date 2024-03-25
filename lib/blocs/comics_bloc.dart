import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/comics_model.dart';
import '../services/api_manager.dart'; // Changé en ApiManager pour refléter le renommage suggéré précédemment

// Définition des événements du BLoC pour les comics
abstract class ComicEvent extends Equatable {
  const ComicEvent();
}

// Événement déclenché pour la récupération des comics
class ComicFetchEvent extends ComicEvent {
  @override
  List<Object> get props => []; // Pas de propriétés ici, donc une liste vide
}

// Définition des états possibles pour le BLoC des comics
abstract class ComicState extends Equatable {
  const ComicState();
}

// État initial, aucun comics n'a encore été chargé
class ComicInitialState extends ComicState {
  @override
  List<Object> get props => [];
}

// État de chargement, indique que les comics sont en cours de récupération
class ComicLoadingState extends ComicState {
  @override
  List<Object> get props => [];
}

// État de succès, les comics ont été chargés
class ComicLoadedState extends ComicState {
  final List<Comic> comics; // Utilise ComicDetails pour une meilleure clarté

  const ComicLoadedState(this.comics);

  @override
  List<Object> get props => [comics];
}

// État d'erreur, indique qu'une erreur est survenue lors du chargement des comics
class ComicErrorState extends ComicState {
  final String message; // Renommé en 'message' pour une meilleure clarté

  const ComicErrorState(this.message);

  @override
  List<Object> get props => [message];
}

// Le BLoC qui gère l'état et la logique métier pour les comics
class ComicBloc extends Bloc<ComicEvent, ComicState> {
  final ApiManager
      apiManager; // Renommé pour correspondre à la classe ApiManager

  ComicBloc(this.apiManager) : super(ComicInitialState()) {
    // Gestion de l'événement de récupération des comics
    on<ComicFetchEvent>((event, emit) async {
      emit(ComicLoadingState()); // État de chargement
      try {
        final comics = await apiManager.fetchComics(); // Récupère les comics
        emit(
            ComicLoadedState(comics)); // État de succès avec les comics chargés
      } catch (e) {
        emit(ComicErrorState(
            'Failed to fetch comics: $e')); // État d'erreur avec le message d'erreur
      }
    });
  }
}
