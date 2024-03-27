import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:test1/manager/api_manager.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/comics_bloc.dart';
import '../blocs/movies_bloc.dart';
import '../blocs/series_bloc.dart';
import '../blocs/character_bloc.dart';
import '../blocs/search_bloc.dart';

import '../models_api/comics_model.dart';
import '../models_api/movies_model.dart';
import '../models_api/series_model.dart';
import '../models_api/character_model.dart';
import '../models_api/news_model.dart';

import '../couleurs/couleurs.dart';

import 'movies/movies_ecran_list.dart';
import 'series/series_ecran_list.dart';
import 'comics/comics_ecran_list.dart';
import 'search/search_ecran.dart';

import '../manager/api_manager.dart';

import 'widgets/movies/movieshome.dart';
import 'widgets/series/serieshome.dart';
import 'widgets/comics/comicshome.dart';

//import '../blocs/news_bloc.dart';
//import '../blocs/search_bloc.dart';

// Définition des onglets de l'application avec leurs étiquettes et icônes correspondantes
enum AppTabs {
  accueil(
    'Accueil',
    'assets/SVG/navbar_home.svg',
  ),
  comics(
    'Comics',
    'assets/SVG/navbar_comics.svg',
  ),
  series(
    'Séries',
    'assets/SVG/navbar_series.svg',
  ),
  films(
    'Films',
    'assets/SVG/navbar_movies.svg',
  ),
  recherche(
    'Recherche',
    'assets/SVG/navbar_search.svg',
  );

  final String label;
  final String svgAsset;

// Constructeur pour initialiser un onglet avec un label et un chemin d'icône SVG.
  const AppTabs(this.label, this.svgAsset);
}

// Classe d'écran principal étendant StatefulWidget pour permettre des mises à jour de l'état.
class MainScreen extends StatefulWidget {
  // Constructeur standard pour un StatefulWidget.
  const MainScreen({Key? key}) : super(key: key);

  @override
  // Création de l'état pour MainScreen.
  State<MainScreen> createState() => _MainScreenState();
}

// État associé à MainScreen, gérant la logique et l'affichage de l'interface utilisateur.
class _MainScreenState extends State<MainScreen> {
  // Instance d'ApiManager pour gérer les appels réseau.
  final ApiManager apiManager = ApiManager();
  // Position actuelle de l'onglet sélectionné.
  int _currentTabPosition = 0;
  // Contrôleur pour le PageView permettant la navigation entre les pages.
  final PageController _pageController = PageController();

  // Méthode appelée lorsqu'un onglet est sélectionné, mettant à jour l'état et naviguant à la page correspondante.
  void _onItemTapped(int position) {
    setState(() {
      _currentTabPosition = position; // Mise à jour de l'onglet actuel.
    });
    _pageController.jumpToPage(position); // Navigue à la page sélectionnée.
  }

  @override
  void initState() {
    super.initState();
    // Initialisation des données des Blocs après un court délai pour éviter les erreurs de contexte.
    Future.delayed(Duration.zero, () {
      // Déclenche les événements pour charger les données depuis l'API.
      BlocProvider.of<ComicBloc>(context).add(ComicFetchEvent());
      BlocProvider.of<MoviesBloc>(context).add(MovieFetchEvent());
      BlocProvider.of<SeriesBloc>(context).add(SeriesFetchEvent());
      BlocProvider.of<CharacterBloc>(context).add(CharacterFetchAllEvent());
      // Exemple commenté pour montrer comment charger d'autres types de données.
      //BlocProvider.of<NewsBloc>(context).add(FetchNewsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF15232E),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          Scaffold(
            backgroundColor:
                AppColors.backgroundColor, // Arrière-plan de couleur uniforme
            body: ListView(
              children: <Widget>[
                //_buildSectionContainer('Actualités', _buildNewsSection()),
                _buildSectionContainer(
                    'Comics populaires', _buildComicsSection()),
                _buildSectionContainer(
                    'Séries populaires', _buildSeriesSection()),
                _buildSectionContainer(
                    'Films populaires', _buildMoviesSection()),
                //_buildSectionContainer('Personnages populaires', _buildCharactersSection()),
              ],
            ),
          ),
          // Autres écrans à ajouter ici
          const ComicsListScreen(),
          const SeriesListScreen(),
          const MoviesListScreen(),
          BlocProvider<SearchBloc>(
            create: (BuildContext context) => SearchBloc(apiManager),
            child: const SearchScreen(),
          ),
        ],
        onPageChanged: (index) {
          setState(() {
            _currentTabPosition = index;
          });
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildSectionContainer(String title, Widget child) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          _buildSectionTitle(title),
          child,
        ],
      ),
    );
  }

// Construit le titre pour chaque section de contenu.
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors
              .white, // Le titre de la section en blanc pour contraster avec le fond.
        ),
      ),
    );
  }

// Construit la section des films en fonction de l'état actuel du bloc des films.
  Widget _buildMoviesSection() {
    return BlocBuilder<MoviesBloc, MovieState>(
      builder: (context, state) {
        if (state is MovieLoadingState) {
          // Affiche un indicateur de progression pendant le chargement des films.
          return const CircularProgressIndicator();
        } else if (state is MovieLoadedState) {
          // Une fois les films chargés, construit et affiche la liste des films.
          return _buildMoviesList(state.movies);
        } else if (state is MovieErrorState) {
          // En cas d'erreur de chargement, affiche le message d'erreur.
          return Text(state.error);
        }
        // Retourne un conteneur vide si l'état initial ou inattendu.
        return Container();
      },
    );
  }

// Construit une liste horizontale de widgets pour chaque film.
  Widget _buildMoviesList(List<Movie> movies) {
    return SizedBox(
      height: 200, // Hauteur fixe pour la liste de films.
      child: ListView.builder(
        scrollDirection:
            Axis.horizontal, // Définit la liste pour défiler horizontalement.
        itemCount:
            movies.length, // Nombre d'éléments basé sur la liste des films.
        itemBuilder: (context, index) {
          final movie = movies[index]; // Obtient le film courant par index.
          // Retourne un widget pour le film courant.
          return MovieHomeWidget(movie: movie);
        },
      ),
    );
  }

  Widget _buildSeriesSection() {
    return BlocBuilder<SeriesBloc, SeriesState>(
      builder: (context, state) {
        if (state is SeriesLoadingState) {
          return const CircularProgressIndicator();
        } else if (state is SeriesLoadedState) {
          return _buildSeriesList(state.series);
        } else if (state is SeriesErrorState) {
          return Text(state.error);
        }
        return Container();
      },
    );
  }

  Widget _buildSeriesList(List<Series> series) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: series.length,
        itemBuilder: (context, index) {
          final serie = series[index];
          return SeriesHomeWidget(
            series: serie,
          );
        },
      ),
    );
  }

  Widget _buildComicsSection() {
    return BlocBuilder<ComicBloc, ComicState>(
      builder: (context, state) {
        if (state is ComicLoadingState) {
          return const CircularProgressIndicator();
        } else if (state is ComicLoadedState) {
          return _buildComicsList(state.comics);
        } else if (state is ComicErrorState) {
          return Text(state.error);
        }
        return Container(); // State initial ou autre
      },
    );
  }

  Widget _buildComicsList(List<Comic> comics) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: comics.length,
        itemBuilder: (context, index) {
          final comic = comics[index];
          return ComicsHomeWidget(
            comic: comic, // Passez l'objet comic ici
          );
        },
      ),
    );
  }

// Construit la barre de navigation inférieure.
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black38,
              spreadRadius: 0,
              blurRadius: 10), // Ombre pour un effet de profondeur.
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(23),
          topRight: Radius.circular(23),
        ),
        child: BottomNavigationBar(
          backgroundColor:
              Color(0xFF0F1E2B), // Couleur de fond de la barre de navigation.
          currentIndex:
              _currentTabPosition, // Index de l'onglet actuellement sélectionné.
          type: BottomNavigationBarType
              .fixed, // Type fixe pour maintenir la barre visible.
          items: AppTabs.values
              .asMap()
              .entries
              .map((entry) => _buildBottomNavBarItem(
                    entry.value.label,
                    entry.value.svgAsset,
                    entry.key,
                  ))
              .toList(), // Génère les items de la barre de navigation.
          onTap:
              _onItemTapped, // Gère le tap sur les items pour changer de page.
        ),
      ),
    );
  }

// Construit chaque item de la barre de navigation avec une icône et un label.
  BottomNavigationBarItem _buildBottomNavBarItem(
      String label, String svgAsset, int index) {
    final isSelected =
        _currentTabPosition == index; // Détermine si l'item est sélectionné.
    final color = isSelected
        ? Color.fromRGBO(
            55, 146, 255, 1) // Couleur lorsque l'item est sélectionné.
        : Color.fromRGBO(
            119, 139, 168, 1); // Couleur lorsque l'item n'est pas sélectionné.

    return BottomNavigationBarItem(
      label: '',
      icon: Container(
        width: 74,
        height: 66,
        decoration: BoxDecoration(
          color: isSelected
              ? Color.fromRGBO(
                  55, 146, 255, 0.08) // Fond de l'icône lorsque sélectionné.
              : Colors.transparent, // Transparent lorsque non sélectionné.
          borderRadius: BorderRadius.circular(23),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgAsset,
              width: 31, // Définis la largeur de l'icône
              color: color,
            ),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
