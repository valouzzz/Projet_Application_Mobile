import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models_api/character_model.dart';
import '../models_api/comics_model.dart';
import '../models_api/movies_model.dart';
import '../models_api/series_model.dart';
import '../manager/api_manager.dart'; // Ajusté pour utiliser ApiManager

// Événements de recherche
abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

// Événement pour effectuer une recherche
class PerformSearchEvent extends SearchEvent {
  final String query;

  const PerformSearchEvent(this.query);

  @override
  List<Object> get props => [query];
}

// États de recherche
abstract class SearchState extends Equatable {
  const SearchState();
}

// État initial de la recherche
class SearchInitialState extends SearchState {
  @override
  List<Object> get props => [];
}

// État de chargement de la recherche
class SearchLoadingState extends SearchState {
  @override
  List<Object> get props => [];
}

// État des résultats de la recherche
class SearchResultsState extends SearchState {
  // Les résultats sont stockés dans une structure de données plus typée pour la clarté
  final Map<String, List<Map<String, String>>> results;

  const SearchResultsState(this.results);

  @override
  List<Object> get props => [results];
}

// État d'erreur de la recherche
class SearchErrorState extends SearchState {
  final String error; // Renommé pour une meilleure clarté

  const SearchErrorState(this.error);

  @override
  List<Object> get props => [error];
}

// Bloc de recherche
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ApiManager apiManager; // Utilise ApiManager

  SearchBloc(this.apiManager) : super(SearchInitialState()) {
    on<PerformSearchEvent>(_onPerformSearchEvent);
  }

  Future<void> _onPerformSearchEvent(
      PerformSearchEvent event, Emitter<SearchState> emit) async {
    emit(SearchLoadingState());
    try {
      // Récupération asynchrone des résultats de la recherche pour chaque catégorie
      final comicsFuture = apiManager.searchComics(event.query);
      final moviesFuture = apiManager.searchMovies(event.query);
      final seriesFuture = apiManager.searchSeries(event.query);
      final charactersFuture = apiManager.searchCharacters(event.query);

      // Attendre les résultats de tous les appels API
      final comics = await comicsFuture;
      final movies = await moviesFuture;
      final series = await seriesFuture;
      final characters = await charactersFuture;

      // Construire les résultats de la recherche
      Map<String, List<Map<String, String>>> searchResults = {
        'Comics': comics
            .map((comic) =>
                {'name': comic.title, 'imageUrl': comic.coverImageUrl})
            .toList(),
        'Movies': movies
            .map((movie) =>
                {'name': movie.title, 'imageUrl': movie.coverImageUrl})
            .toList(),
        'Series': series
            .map((serie) =>
                {'name': serie.name, 'imageUrl': serie.coverImageUrl})
            .toList(),
        'Characters': characters
            .map((character) =>
                {'name': character.name, 'imageUrl': character.profileImageUrl})
            .toList(),
      };

      emit(SearchResultsState(searchResults));
    } catch (e) {
      emit(SearchErrorState('Failed to perform search: $e'));
    }
  }
}
