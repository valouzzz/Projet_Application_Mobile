import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/comics_bloc.dart';
import '../widgets/comics/comics.dart';
import '../../couleurs/couleurs.dart';

class ComicsListScreen extends StatelessWidget {
  const ComicsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ComicBloc>(context).add(ComicFetchEvent());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comics les plus populaires',
            style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors
            .seeMoreBackground, // Utilisez la couleur définie dans theme.dart
      ),
      body: BlocBuilder<ComicBloc, ComicState>(
        builder: (context, state) {
          if (state is ComicLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ComicLoadedState) {
            return ListView.separated(
              itemCount: state.comics.length,
              separatorBuilder: (context, index) => Divider(
                  color: AppColors.seeMoreBackground), // Diviseur personnalisé
              itemBuilder: (context, index) {
                final comic = state.comics[index];
                return ComicsWidget(comic: comic);
              },
            );
          } else if (state is ComicErrorState) {
            return Center(
              child: Text('Erreur: ${state.error}'),
            );
          } else {
            return const Center(
                child:
                    Text('Aucune donnée. Swipez vers le bas pour rafraîchir.'));
          }
        },
      ),
      backgroundColor:
          AppColors.seeMoreBackground, // Mettez la couleur de fond ici
    );
  }
}
