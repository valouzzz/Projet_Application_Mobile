import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'blocs/comics_bloc.dart';
import 'blocs/episodes_bloc.dart';
import 'blocs/movies_bloc.dart';
import 'blocs/series_bloc.dart';
import 'blocs/news_bloc.dart';
import 'blocs/character_bloc.dart';

import 'services/api_manager.dart';

import 'screens/main_screen.dart';

Future main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Assurez-vous d'initialiser les bindings de Flutter.
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Crée une instance de ton service API.
    final ApiManager apiManager = ApiManager();

    // Utilise MultiBlocProvider pour injecter les blocs.
    return MultiBlocProvider(
      providers: [
        BlocProvider<ComicBloc>(
          create: (context) => ComicBloc(apiManager),
        ),
        BlocProvider<SeriesBloc>(
          create: (context) => SeriesBloc(apiManager: apiManager),
        ),
        BlocProvider<MoviesBloc>(
          create: (context) => MoviesBloc(apiManager),
        ),
        BlocProvider<CharacterBloc>(
          create: (context) => CharacterBloc(apiManager),
        ),
        BlocProvider<EpisodeBloc>(
          create: (context) => EpisodeBloc(apiManager: apiManager),
        ),
        BlocProvider<NewsBloc>(
          create: (context) => NewsBloc(apiManager: apiManager),
        ),
        // Ajoute d'autres BlocProviders si nécessaire...
      ],
      child: MaterialApp(
        title: 'Comic App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MainScreen(),
      ),
    );
  }
}
