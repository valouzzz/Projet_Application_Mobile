import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'pages/comics/comics.dart'; // Importe les pages spécifiques ici
import 'pages/films/films.dart';
import 'pages/recherche/recherche.dart';
import 'pages/series/series.dart';
import 'pages/accueil/accueil.dart';

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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ComicsApp',
      debugShowCheckedModeBanner: false,
      home: const MainScreen(), // Utilise MainScreen comme point d'entrée
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentTabPosition = 0;

  final List<Widget> _pages = [
    AccueilPage(), // Remplace par tes widgets de page réels
    ComicsPage(),
    SeriesPage(),
    FilmsPage(),
    RecherchePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF15232E),
      body: _pages[_currentTabPosition],
      bottomNavigationBar: Container(
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
          child: _buildBottomNavigationBar(),
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
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
      onTap: (int position) {
        setState(() {
          _currentTabPosition = position;
        });
      },
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
              width:
                  31, // Définis la largeur de l'icône, par exemple à 24 pixels
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
