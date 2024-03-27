import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models_api/series_model.dart';
import '../manager/api_manager.dart'; // Ajusté pour utiliser ApiManager

// Définit les événements gérés par SeriesBloc
abstract class SeriesEvent extends Equatable {
  const SeriesEvent();
}

// Événement déclenché pour charger les séries
class SeriesFetchEvent extends SeriesEvent {
  @override
  List<Object> get props => [];
}

// Définit les états possibles pour SeriesBloc
abstract class SeriesState extends Equatable {
  const SeriesState();
}

// État initial, avant tout chargement de série
class SeriesInitialState extends SeriesState {
  @override
  List<Object> get props => [];
}

// État de chargement des séries
class SeriesLoadingState extends SeriesState {
  @override
  List<Object> get props => [];
}

// État lorsque les séries sont chargées avec succès
class SeriesLoadedState extends SeriesState {
  final List<Series> series; // Utilise SeriesDetails pour la clarté

  const SeriesLoadedState(this.series);

  @override
  List<Object> get props => [series];
}

// État en cas d'erreur lors du chargement des séries
class SeriesErrorState extends SeriesState {
  final String message; // Renommé pour une meilleure clarté

  const SeriesErrorState(this.message);

  @override
  List<Object> get props => [message];

  get error => null;
}

// Bloc qui gère le chargement des séries
class SeriesBloc extends Bloc<SeriesEvent, SeriesState> {
  final ApiManager apiManager; // Utilise ApiManager pour une cohérence

  SeriesBloc({required this.apiManager}) : super(SeriesInitialState()) {
    on<SeriesFetchEvent>((event, emit) async {
      emit(SeriesLoadingState());
      try {
        final series = await apiManager
            .fetchSeries(); // Appel à la méthode renommée dans ApiManager
        emit(SeriesLoadedState(series));
      } catch (e) {
        emit(SeriesErrorState(
            'Failed to fetch series: $e')); // Utilisation d'un message d'erreur plus clair
      }
    });
  }
}
