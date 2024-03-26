import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:test1/services/api_manager.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/comics_bloc.dart';
import '../blocs/movies_bloc.dart';
import '../blocs/series_bloc.dart';
import '../blocs/character_bloc.dart';

import '../models/comics_model.dart';
import '../models/movies_model.dart';
import '../models/series_model.dart';
import '../models/character_model.dart';
import '../models/news_model.dart';

import '../couleurs/couleurs.dart';

import '../screens/movies_list_screen.dart';

import '../services/api_manager.dart';

import '../widgets/movieshome.dart';

//import '../blocs/news_bloc.dart';
//import '../blocs/search_bloc.dart';

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

  const AppTabs(this.label, this.svgAsset);
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ApiManager apiManager = ApiManager();
  int _currentTabPosition = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int position) {
    setState(() {
      _currentTabPosition = position;
    });
    _pageController.jumpToPage(position);
  }

  @override
  void initState() {
    super.initState();
    // Initialisation des Blocs après un court délai
    Future.delayed(Duration.zero, () {
      // Fetch data from the blocs
      BlocProvider.of<ComicBloc>(context).add(ComicFetchEvent());
      BlocProvider.of<MoviesBloc>(context).add(MovieFetchEvent());
      BlocProvider.of<SeriesBloc>(context).add(SeriesFetchEvent());
      BlocProvider.of<CharacterBloc>(context).add(CharacterFetchAllEvent());
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
            //backgroundColor: AppColors.backgroundColor, // Arrière-plan de couleur uniforme
            body: ListView(
              children: <Widget>[
                //_buildSectionContainer('Actualités', _buildNewsSection()),
                //_buildSectionContainer('Comics populaires', _buildComicsSection()),
                //_buildSectionContainer('Séries populaires', _buildSeriesSection()),
                _buildSectionContainer(
                    'Films populaires', _buildMoviesSection()),
                //_buildSectionContainer('Personnages populaires', _buildCharactersSection()),
              ],
            ),
          ),
          // Autres écrans à ajouter ici
          //const ComicsListScreen(),
          //const SeriesListScreen(),
          const MoviesListScreen(),
          /*BlocProvider<SearchBloc>(
            create: (BuildContext context) => SearchBloc(apiService),
            child: const SearchScreen(),
          ),
          */
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildMoviesSection() {
    return BlocBuilder<MoviesBloc, MovieState>(
      builder: (context, state) {
        if (state is MovieLoadingState) {
          return const CircularProgressIndicator();
        } else if (state is MovieLoadedState) {
          return _buildMoviesList(state.movies);
        } else if (state is MovieErrorState) {
          return Text(state.error);
        }
        return Container(); // State initial ou autre
      },
    );
  }

  Widget _buildMoviesList(List<Movie> movies) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return MovieHomeWidget(movie: movie);
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(23),
          topRight: Radius.circular(23),
        ),
        child: BottomNavigationBar(
          backgroundColor: Color(0xFF0F1E2B),
          currentIndex: _currentTabPosition,
          type: BottomNavigationBarType.fixed,
          items: AppTabs.values
              .asMap()
              .entries
              .map((entry) => _buildBottomNavBarItem(
                    entry.value.label,
                    entry.value.svgAsset,
                    entry.key,
                  ))
              .toList(),
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavBarItem(
      String label, String svgAsset, int index) {
    final isSelected = _currentTabPosition == index;
    final color = isSelected
        ? Color.fromRGBO(55, 146, 255, 1) // selected color
        : Color.fromRGBO(119, 139, 168, 1); // unselected color

    return BottomNavigationBarItem(
      label: '',
      icon: Container(
        width: 74,
        height: 66,
        decoration: BoxDecoration(
          color: isSelected
              ? Color.fromRGBO(55, 146, 255, 0.08)
              : Colors.transparent,
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
