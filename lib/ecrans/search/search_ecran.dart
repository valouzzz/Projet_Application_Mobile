import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../blocs/search_bloc.dart';
import '../../couleurs/couleurs.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  void _onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      context.read<SearchBloc>().add(PerformSearchEvent(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Comic, film, série, personnage...',
                        hintStyle: const TextStyle(
                            color: AppColors.bottomBarUnselectedText),
                        prefixIcon: const Icon(Icons.search,
                            color: AppColors.bottomBarUnselectedText),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: AppColors.backgroundColor,
                      ),
                      onSubmitted:
                          _onSearchSubmitted, // Recherche déclenchée sur appui Enter
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search,
                        color: AppColors.bottomBarUnselectedText),
                    onPressed: () => _onSearchSubmitted(
                        searchController.text), // Recherche déclenchée sur clic
                  ),
                ],
              ),
            ),
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SearchResultsState) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics:
                        NeverScrollableScrollPhysics(), // Désactiver le scrolling sur la ListView
                    itemCount: state.results.entries.length,
                    itemBuilder: (context, index) {
                      final category =
                          state.results.entries.elementAt(index).key;
                      final items =
                          state.results.entries.elementAt(index).value;

                      return ExpansionTile(
                        backgroundColor: AppColors.backgroundColor,
                        title: Text(category,
                            style: const TextStyle(color: Colors.white)),
                        children: items.map((item) {
                          // S'assurer que l'URL de l'image et le nom ne sont pas nulls
                          final String imageUrl = item['imageUrl'] ??
                              ''; // Utilisez une chaîne vide si null
                          final String name = item['name'] ??
                              'Inconnu'; // Utilisez 'Inconnu' ou toute autre chaîne par défaut si null

                          return ListTile(
                            leading: imageUrl.isNotEmpty
                                ? Image.network(imageUrl, width: 50, height: 50)
                                : SizedBox(
                                    width: 50,
                                    height:
                                        50), // Affiche un espace vide si l'URL de l'image est vide
                            title: Text(name,
                                style: const TextStyle(color: Colors.white)),
                            onTap: () {
                              // Naviguer vers le détail de l'élément sélectionné si nécessaire
                            },
                          );
                        }).toList(),
                      );
                    },
                  );
                } else if (state is SearchErrorState) {
                  return Center(
                    child: Text(state.error,
                        style: const TextStyle(color: Colors.white)),
                  );
                } else {
                  return Center(
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'res/svg/astronaut.svg',
                          width: 200,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Saisissez une recherche pour trouver un comic, film, série ou personnage.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.bottomBarUnselectedText,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
