import 'package:flutter/material.dart';
import '../../models_api/movies_model.dart';
import '../../couleurs/couleurs.dart';
import '../widgets/movies/details/characters_tab.dart';
import '../widgets/movies/details/history_tab.dart';
import '../widgets/movies/details/infos_tab.dart';

// Écran de détails pour les films, utilisant un TabController pour gérer les onglets de navigation.
class MoviesDetailsScreen extends StatefulWidget {
  final Movie
      movies; // Instance de Movie contenant les détails du film sélectionné.

  // Constructeur initialisant l'écran avec les détails du film.
  const MoviesDetailsScreen({Key? key, required this.movies}) : super(key: key);

  @override
  // Création de l'état pour MoviesDetailsScreen.
  State<MoviesDetailsScreen> createState() => _MoviesDetailsScreenState();
}

// État associé à MoviesDetailsScreen, gérant la logique de l'écran de détails des films.
class _MoviesDetailsScreenState extends State<MoviesDetailsScreen>
    with SingleTickerProviderStateMixin {
  // Mixin utilisé pour le contrôleur d'animation.
  late TabController _tabController; // Contrôleur pour les onglets.

  @override
  void initState() {
    super.initState();
    // Initialisation du TabController avec trois onglets.
    _tabController = TabController(length: 3, vsync: this);
  }

  // Construit la section affichant l'image du film et quelques informations de base.
  Widget _buildMoviesImage() {
    return Row(
      // Organisation horizontale pour l'image et les informations textuelles.
      children: [
        Image.network(
          widget.movies.coverImageUrl, // URL de l'image de couverture du film.
          width: 100, // Largeur fixe pour l'image.
          fit: BoxFit
              .cover, // Remplissage pour s'assurer que l'image couvre bien l'espace alloué.
        ),
        Expanded(
          // Utilise l'espace restant pour les informations textuelles.
          child: Column(
            // Organisation verticale pour les informations textuelles.
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.movies.runningTime} min', // Durée du film en minutes.
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Sortie: ${widget.movies.releaseDate}', // Date de sortie du film.
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Construit l'interface utilisateur principale de l'écran de détails des films.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        // Utilise un Stack pour superposer les éléments de l'UI.
        children: [
          Opacity(
            opacity:
                0.5, // Applique une opacité à l'image de fond pour atténuer son intensité visuelle.
            child: Image.network(
              widget.movies
                  .coverImageUrl, // Image de couverture du film en arrière-plan.
              fit: BoxFit
                  .cover, // S'assure que l'image couvre toute la zone disponible.
              height: double
                  .infinity, // Étend l'image en hauteur autant que possible.
              width: double
                  .infinity, // Étend l'image en largeur autant que possible.
              alignment: Alignment.center, // Centre l'image.
            ),
          ),
          Positioned(
            // AppBar personnalisée placée en haut de l'écran.
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              title: Text(widget.movies.title, // Titre du film.
                  style: TextStyle(color: Colors.white)),
              backgroundColor:
                  AppColors.seeMoreBackground, // Couleur de fond de l'AppBar.
              elevation: 0, // Supprime l'ombre sous l'AppBar.
              leading: IconButton(
                icon: Icon(Icons.arrow_back,
                    color: Colors.white), // Bouton retour.
                onPressed: () {
                  Navigator.of(context)
                      .pop(); // Retour à l'écran précédent lors du clic.
                },
              ),
            ),
          ),
          Positioned(
            // Conteneur pour le contenu principal sous l'AppBar.
            top: kToolbarHeight +
                MediaQuery.of(context)
                    .padding
                    .top, // Positionnement sous l'AppBar.
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              // Permet le défilement du contenu.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment
                    .stretch, // Étire le contenu sur la largeur disponible.
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        _buildMoviesImage(), // Construit et affiche l'image et les infos de base du film.
                  ),
                  _buildTabBar(), // Construit la barre d'onglets pour la navigation.
                  Container(
                    // Conteneur pour les vues des onglets.
                    height: MediaQuery.of(context).size.height -
                        kToolbarHeight -
                        MediaQuery.of(context)
                            .padding
                            .top, // Hauteur ajustée pour remplir l'espace disponible.
                    child: TabBarView(
                      controller:
                          _tabController, // Contrôleur pour synchroniser les vues avec les onglets.
                      children: [
                        HistoryTab(movie: widget.movies), // Onglet Synopsis.
                        CharactersTab(
                            movie: widget.movies), // Onglet Personnages.
                        InfosTab(movie: widget.movies), // Onglet Infos.
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

// Construit la barre d'onglets avec des labels pour chaque section.
  TabBar _buildTabBar() {
    return TabBar(
      controller:
          _tabController, // Utilise le contrôleur d'onglets initialisé dans initState.
      indicatorColor: AppColors
          .orange, // Couleur de l'indicateur sous l'onglet sélectionné.
      labelColor: Colors.white, // Couleur du texte pour l'onglet sélectionné.
      unselectedLabelColor:
          Colors.white60, // Couleur du texte pour les onglets non sélectionnés.
      tabs: [
        Tab(text: 'Synopsis'), // Onglet pour le synopsis du film.
        Tab(text: 'Personnages'), // Onglet pour la liste des personnages.
        Tab(
            text:
                'Infos'), // Onglet pour les informations supplémentaires du film.
      ],
    );
  }
}
