import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/news_model.dart';
import '../services/api_manager.dart'; // Ajusté pour utiliser ApiManager

// Définit les événements gérés par NewsBloc
abstract class NewsEvent extends Equatable {
  const NewsEvent();
}

// Événement déclenché pour charger les actualités
class NewsFetchEvent extends NewsEvent {
  @override
  List<Object> get props => [];
}

// Définit les états possibles pour NewsBloc
abstract class NewsState extends Equatable {
  const NewsState();
}

// État initial, avant tout chargement d'actualité
class NewsInitialState extends NewsState {
  @override
  List<Object> get props => [];
}

// État de chargement des actualités
class NewsLoadingState extends NewsState {
  @override
  List<Object> get props => [];
}

// État lorsque les actualités sont chargées avec succès
class NewsLoadedState extends NewsState {
  final List<News> news; // Utilise NewsArticle pour la clarté

  const NewsLoadedState(this.news);

  @override
  List<Object> get props => [news];
}

// État en cas d'erreur lors du chargement des actualités
class NewsErrorState extends NewsState {
  final String message; // Renommé pour une meilleure clarté

  const NewsErrorState(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc qui gère le chargement des actualités
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final ApiManager apiManager; // Utilise ApiManager pour une cohérence

  NewsBloc({required this.apiManager}) : super(NewsInitialState()) {
    on<NewsFetchEvent>((event, emit) async {
      emit(NewsLoadingState());
      try {
        final news = await apiManager
            .fetchNews(); // Appel à la méthode renommée dans ApiManager
        emit(NewsLoadedState(news));
      } catch (e) {
        emit(NewsErrorState(
            'Failed to fetch news: $e')); // Utilisation d'un message d'erreur plus clair
      }
    });
  }
}
