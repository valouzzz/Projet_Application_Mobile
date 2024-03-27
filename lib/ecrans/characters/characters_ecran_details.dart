import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart'; // Importez ce package
import '../../models_api/character_model.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailsScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character.name), // Titre avec le nom du personnage
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.network(character.profileImageUrl,
                fit: BoxFit.cover), // Affiche l'image du personnage
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('Description',
                      style: Theme.of(context).textTheme.titleLarge),
                  SingleChildScrollView(
                    // Utilisez HtmlWidget pour afficher la description HTML
                    child: HtmlWidget(
                      character
                          .bio, // Utilisez character.description pour afficher la description en HTML
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge, // Appliquez le style de texte souhaité
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Ici, vous pouvez ajouter d'autres informations pertinentes sur le personnage
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
