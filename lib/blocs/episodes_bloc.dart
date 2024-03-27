import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models_api/episode_model.dart';
import '../manager/api_manager.dart'; // Adjusted for naming consistency

// Defines events for episode-related actions
abstract class EpisodeEvent extends Equatable {
  const EpisodeEvent();
  @override
  List<Object?> get props => [];
}

// Event to fetch episodes for a specific series ID
class FetchEpisodesEvent extends EpisodeEvent {
  final int seriesId;

  const FetchEpisodesEvent(this.seriesId);

  @override
  List<Object?> get props => [seriesId];
}

// Defines the possible states for the episode data
abstract class EpisodeState extends Equatable {
  const EpisodeState();
  @override
  List<Object?> get props => [];
}

// Initial state, no episodes have been fetched yet
class EpisodeInitialState extends EpisodeState {}

// State indicating that the episodes are currently being loaded
class EpisodeLoadingState extends EpisodeState {}

// State when episodes have been successfully loaded
class EpisodeLoadedState extends EpisodeState {
  final List<Episode> episodes; // Renamed to EpisodeDetails for clarity

  const EpisodeLoadedState(this.episodes);

  @override
  List<Object?> get props => [episodes];
}

// State indicating an error occurred while fetching episodes
class EpisodeErrorState extends EpisodeState {
  final String message; // Renamed for clarity

  const EpisodeErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc to handle fetching and managing episode data
class EpisodeBloc extends Bloc<EpisodeEvent, EpisodeState> {
  final ApiManager apiManager; // Renamed for consistency and clarity

  EpisodeBloc({required this.apiManager}) : super(EpisodeInitialState()) {
    on<FetchEpisodesEvent>((event, emit) async {
      emit(EpisodeLoadingState());
      try {
        // Attempt to fetch episodes using the series ID
        final episodes =
            await apiManager.fetchEpisodesBySeriesId(event.seriesId);
        emit(EpisodeLoadedState(episodes));
      } catch (error) {
        emit(EpisodeErrorState(
            'Failed to fetch episodes for series ${event.seriesId}: $error'));
      }
    });
  }
}
