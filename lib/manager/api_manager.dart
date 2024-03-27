import 'package:http/http.dart' as http;
import '../models_api/movies_model.dart';
import '../models_api/series_model.dart';
import '../models_api/comics_model.dart';

import '../models_api/character_model.dart';
import '../models_api/news_model.dart';

import '../models_api/episode_model.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class ApiManager {
  // Utilisation de variables pour les clés d'API stockées dans un fichier .env
  var comicApiKey = dotenv.env['COMIC_API_KEY'];
  var newsApiKey = dotenv.env['NEWS_API_KEY'];

  // Méthode pour récupérer les comics
  Future<List<Comic>> fetchComics() async {
    var endpointUrl = Uri.parse(
        'https://comicvine.gamespot.com/api/issues?api_key=$comicApiKey&format=json');
    return _fetchDataFromApi<Comic>(
        endpointUrl, (json) => Comic.fromJson(json));
  }

  // Méthode pour récupérer les films
  Future<List<Movie>> fetchMovies() async {
    var endpointUrl = Uri.parse(
        'https://comicvine.gamespot.com/api/movies?api_key=$comicApiKey&format=json');
    return _fetchDataFromApi<Movie>(
        endpointUrl, (json) => Movie.fromJson(json));
  }

  // Méthode pour récupérer les séries
  Future<List<Series>> fetchSeries() async {
    var endpointUrl = Uri.parse(
        'https://comicvine.gamespot.com/api/series_list?api_key=$comicApiKey&format=json');
    return _fetchDataFromApi<Series>(
        endpointUrl, (json) => Series.fromJson(json));
  }

  Future<List<Character>> fetchCharactersByMoviesId(int moviesId) async {
    // Constructing the URL to query the API with the movie ID as a filter
    var endpointUrl = Uri.parse(
        'https://comicvine.gamespot.com/api/character?api_key=$comicApiKey&format=json&filter=movies:$moviesId');

    try {
      var response = await http.get(endpointUrl);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['results'] is List) {
          List<dynamic> charactersJson = data['results'];
          List<Character> characters = charactersJson
              .map((charactersJson) => Character.fromJson(charactersJson))
              .toList();
          return characters;
        } else {
          throw Exception('Expected a list of results but did not find one.');
        }
      } else {
        // Handle other than status 200 OK responses
        throw Exception(
            'Error fetching characters: HTTP ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions during the API call
      throw Exception('Exception during API call: $e');
    }
  }

  // Endpoint pour les personnages
  Future<List<Character>> fetchCharacters() async {
    var endpointUrl = Uri.parse(
        'https://comicvine.gamespot.com/api/characters?api_key=$comicApiKey&format=json');
    try {
      var response = await http.get(endpointUrl);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        List results = data['results'] as List;
        return results
            .map((json) => Character.fromJson(json))
            .cast<Character>()
            .toList();
      } else {
        print("Erreur lors de l'appel API: Statut HTTP ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Exception lors de l'appel API: $e");
      return [];
    }
  }

  // Endpoint pour les news

  Future<List<News>> fetchNews() async {
    var endpointUrl = Uri.parse(
        'http://www.gamespot.com/api/articles/?api_key=$comicApiKey&format=json&filter=categories:48');

    try {
      var response = await http.get(endpointUrl);

      print('Response status: ${response.statusCode}');
      print(
          'Response body: ${response.body}'); // Cette ligne affichera le JSON brut

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        List results = data['results'] as List;
        return results.map((json) => News.fromJson(json)).cast<News>().toList();
      } else {
        print("Erreur lors de l'appel API: Statut HTTP ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Exception lors de l'appel API: $e");
      return [];
    }
  }

// Exemple d'une méthode ajoutée pour la récupération des épisodes d'une série spécifique
  Future<List<Episode>> fetchEpisodesBySeriesId(int seriesId) async {
    // Constructing the URL to query the API with the series ID as a filter
    var endpointUrl = Uri.parse(
        'https://comicvine.gamespot.com/api/episodes?api_key=$comicApiKey&format=json&filter=series:$seriesId');

    try {
      var response = await http.get(endpointUrl);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // Check if 'results' is a list and if so, transform each element into an Episode object
        if (data['results'] is List) {
          List<dynamic> episodesJson = data['results'];
          List<Episode> episodes = episodesJson
              .map((episodeJson) => Episode.fromJson(episodeJson))
              .toList();
          return episodes;
        } else {
          throw Exception('Expected a list of results but did not find one.');
        }
      } else {
        // Handle other than status 200 OK responses
        throw Exception('Error fetching episodes: HTTP ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions during the API call
      throw Exception('Exception during API call: $e');
    }
  }

  // Méthode générique pour obtenir des données de l'API
  Future<List<T>> _fetchDataFromApi<T>(Uri url, Function fromJson) async {
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var decodedData = json.decode(response.body);
        List results = decodedData['results'] as List;
        return results.map((json) => fromJson(json)).cast<T>().toList();
      } else {
        // Gestion des erreurs liées au statut HTTP
        print("Erreur de l'API: Statut HTTP ${response.statusCode}");
        return [];
      }
    } catch (e) {
      // Gestion des exceptions lors des appels API
      print("Exception lors de l'appel API: $e");
      return [];
    }
  }

  // Méthodes de recherche (exemplaire pour les comics)
  Future<List<Comic>> searchComics(String searchTerm) async {
    var encodedQuery = Uri.encodeComponent(searchTerm);
    var searchUrl = Uri.parse(
        'https://comicvine.gamespot.com/api/search/?api_key=$comicApiKey&format=json&field_list=name,image&limit=10&resources=issue&query=$encodedQuery');
    return _fetchDataFromApi<Comic>(searchUrl, (json) => Comic.fromJson(json));
  }

  // Recherche des films
  Future<List<Movie>> searchMovies(String query) async {
    var encodedQuery = Uri.encodeComponent(query);
    var url = Uri.parse(
        'https://comicvine.gamespot.com/api/search/?api_key=$comicApiKey&format=json&field_list=name,image&limit=10&resources=movie&query=$encodedQuery');
    return _fetchDataFromApi<Movie>(url, (json) => Movie.fromJson(json));
  }

  // Recherche des séries
  Future<List<Series>> searchSeries(String query) async {
    var encodedQuery = Uri.encodeComponent(query);
    var url = Uri.parse(
        'https://comicvine.gamespot.com/api/search/?api_key=$comicApiKey&format=json&field_list=name,image&limit=10&resources=series&query=$encodedQuery');
    return _fetchDataFromApi<Series>(url, (json) => Series.fromJson(json));
  }

  // Recherche des personnages
  Future<List<Character>> searchCharacters(String query) async {
    var encodedQuery = Uri.encodeComponent(query);
    var url = Uri.parse(
        'https://comicvine.gamespot.com/api/search/?api_key=$comicApiKey&format=json&field_list=name,image&limit=10&resources=character&query=$encodedQuery');
    return _fetchDataFromApi<Character>(
        url, (json) => Character.fromJson(json));
  }
}
