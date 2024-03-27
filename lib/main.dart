import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'manager/api_manager.dart'; // Assure-toi que ce chemin est correct
import 'ecrans/main_screen.dart'; // Assure-toi que ce chemin est correct

// Importe les blocs nécessaires
import 'blocs/comics_bloc.dart';
import 'blocs/series_bloc.dart';
import 'blocs/movies_bloc.dart';
import 'blocs/character_bloc.dart';
import 'blocs/episodes_bloc.dart';
import 'blocs/news_bloc.dart';

// Fonction principale async pour charger des ressources avant de lancer l'app
Future main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Initialisation des bindings de Flutter avant toute opération.
  await dotenv.load(
      fileName:
          ".env"); // Charge les variables d'environnement depuis le fichier .env.
  runApp(MyApp()); // Lance l'application Flutter.
}

// Classe principale MyApp qui étend StatelessWidget.
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructeur de la classe MyApp.

  @override
  Widget build(BuildContext context) {
    // Création de l'instance ApiManager pour interagir avec les API.
    final ApiManager apiManager = ApiManager();

    // Utilisation de MultiBlocProvider pour fournir des instances de blocs à l'arbre de widgets.
    return MultiBlocProvider(
      providers: [
        // Fournit une instance de ComicBloc à l'application.
        BlocProvider<ComicBloc>(
          create: (context) => ComicBloc(apiManager),
        ),
        // Fournit une instance de SeriesBloc.
        BlocProvider<SeriesBloc>(
          create: (context) => SeriesBloc(apiManager: apiManager),
        ),
        // Fournit une instance de MoviesBloc.
        BlocProvider<MoviesBloc>(
          create: (context) => MoviesBloc(apiManager),
        ),
        // Fournit une instance de CharacterBloc.
        BlocProvider<CharacterBloc>(
          create: (context) => CharacterBloc(apiManager),
        ),
        // Fournit une instance de EpisodeBloc.
        BlocProvider<EpisodeBloc>(
          create: (context) => EpisodeBloc(apiManager: apiManager),
        ),
        // Fournit une instance de NewsBloc.
        BlocProvider<NewsBloc>(
          create: (context) => NewsBloc(apiManager: apiManager),
        ),
        // Tu peux ajouter d'autres BlocProviders ici selon les besoins...
      ],
      child: MaterialApp(
        title: 'Comic App', // Titre de l'application.
        theme: ThemeData(
          primarySwatch: Colors.blue, // Couleur principale de l'application.
          visualDensity: VisualDensity
              .adaptivePlatformDensity, // Densité visuelle pour divers appareils.
        ),
        home: MainScreen(), // Écran principal de l'application.
      ),
    );
  }
}
