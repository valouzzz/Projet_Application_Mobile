import 'package:flutter/material.dart';
// Importe tes widgets ici
import 'widgets/header.dart';
import 'widgets/widgetComics.dart';
import 'widgets/widgetFilms.dart';
import 'widgets/widgetSeries.dart';
// Importe les BLoCs et modèles pour les données de l'API

class AccueilPage extends StatelessWidget {
  const AccueilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Utilise un BlocProvider pour fournir les BLoCs à ton arbre de widgets si nécessaire

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenue !'),
        backgroundColor: Color(0xFF15232E),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(), // Ton widget d'en-tête personnalisé
            WidgetSeries(), // Ton widget pour les séries
            WidgetComics(), // Ton widget pour les comics
            WidgetFilms(), // Ton widget pour les films
            // Ajoute d'autres widgets pour d'autres catégories
          ],
        ),
      ),
      // Si tu as besoin d'un Drawer ou d'autres éléments, ajoute-les ici
    );
  }
}
