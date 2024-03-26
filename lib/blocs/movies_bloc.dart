import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/movies_model.dart';
import '../services/api_manager.dart'; // Adjusted to use ApiManager for consistency

// Définit les événements gérés par MoviesBloc
abstract class MovieEvent extends Equatable {
  const MovieEvent();
}

// Événement déclenché pour charger les films
class MovieFetchEvent extends MovieEvent {
  @override
  List<Object> get props =>
      []; // Pas de données supplémentaires nécessaires pour cet événement
}

// Définit les états possibles pour MoviesBloc
abstract class MovieState extends Equatable {
  const MovieState();
}

// État initial, avant tout chargement de film
class MovieInitialState extends MovieState {
  @override
  List<Object> get props => [];
}

// État de chargement des films
class MovieLoadingState extends MovieState {
  @override
  List<Object> get props => [];
}

// État lorsque les films sont chargés avec succès
class MovieLoadedState extends MovieState {
  final List<Movie>
      movies; // Utilise MovieDetails pour la clarté et la cohérence

  const MovieLoadedState(this.movies);

  @override
  List<Object> get props => [movies];
}

// État en cas d'erreur lors du chargement des films
class MovieErrorState extends MovieState {
  final String message; // Renommé pour une meilleure clarté

  const MovieErrorState(this.message);

  @override
  List<Object> get props => [message];

  get error => null;
}

// Bloc qui gère le chargement des films
class MoviesBloc extends Bloc<MovieEvent, MovieState> {
  final ApiManager apiManager; // Utilise ApiManager

  MoviesBloc(this.apiManager) : super(MovieInitialState()) {
    on<MovieFetchEvent>((event, emit) async {
      emit(MovieLoadingState());
      try {
        final movies = await apiManager
            .fetchMovies(); // Appel à la méthode renommée dans ApiManager
        emit(MovieLoadedState(movies));
      } catch (e) {
        emit(MovieErrorState(
            'Failed to fetch movies: $e')); // Utilisation d'un message d'erreur plus clair
      }
    });
  }
}
