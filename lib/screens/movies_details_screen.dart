import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../models/movies_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../couleurs/couleurs.dart';
import '../blocs/character_bloc.dart';
import '../services/api_manager.dart';

class MoviesDetailsScreen extends StatefulWidget {
  final Movie movies;

  const MoviesDetailsScreen({Key? key, required this.movies}) : super(key: key);

  @override
  State<MoviesDetailsScreen> createState() => _MoviesDetailsScreenState();
}

class _MoviesDetailsScreenState extends State<MoviesDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Widget _buildMoviesImage() {
    return Row(
      children: [
        Image.network(
          widget.movies.coverImageUrl,
          width: 100,
          fit: BoxFit.cover,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.movies.runningTime} min',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Sortie: ${widget.movies.releaseDate}',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Image.network(
              widget.movies.coverImageUrl,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              title: Text(widget.movies.title,
                  style: TextStyle(color: Colors.white)),
              backgroundColor: AppColors.seeMoreBackground,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          Positioned(
            top: kToolbarHeight + MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildMoviesImage(),
                  ),
                  _buildTabBar(),
                  Container(
                    height: MediaQuery.of(context).size.height -
                        kToolbarHeight -
                        MediaQuery.of(context).padding.top,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        HistoryTab(movie: widget.movies),
                        CharactersTab(movie: widget.movies),
                        InfosTab(movie: widget.movies),
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

  TabBar _buildTabBar() {
    return TabBar(
      controller: _tabController,
      indicatorColor: AppColors.orange,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white60,
      tabs: [
        Tab(text: 'Synopsis'),
        Tab(text: 'Personnages'),
        Tab(text: 'Infos'),
      ],
    );
  }
}

class HistoryTab extends StatelessWidget {
  final Movie movie;

  const HistoryTab({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.seeMoreBackground, // Set the background color to black
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: HtmlWidget(
          movie.synopsis,
          textStyle: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class CharactersTab extends StatelessWidget {
  final Movie movie;

  const CharactersTab({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ApiManager apiManager =
        ApiManager(); // Ensure this instance is correctly instantiated.

    return BlocProvider<CharacterBloc>(
      create: (context) => CharacterBloc(apiManager)
        ..add(CharacterFetchByMovieIdEvent(movie.id)),
      child: BlocBuilder<CharacterBloc, CharacterState>(
        builder: (context, state) {
          if (state is CharacterLoadingState) {
            return Center(
                child: CircularProgressIndicator(color: Colors.white));
          } else if (state is CharacterLoadedState) {
            return Container(
              color: AppColors
                  .seeMoreBackground, // Set the background color to black
              child: ListView.builder(
                itemCount: state.characters.length,
                itemBuilder: (context, index) {
                  final character = state.characters[index];
                  return Card(
                    color:
                        AppColors.cardBackground, // Set the card color to blue
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(character.profileImageUrl),
                        backgroundColor: Colors.transparent,
                      ),
                      title: Text(character.name,
                          style: TextStyle(color: Colors.white)),
                    ),
                  );
                },
              ),
            );
          } else if (state is CharacterErrorState) {
            return Center(
                child: Text('Error: ${state.error}',
                    style: TextStyle(color: Colors.white)));
          } else {
            return Center(
                child: Text('Start searching for characters',
                    style: TextStyle(color: Colors.white)));
          }
        },
      ),
    );
  }
}

class InfosTab extends StatelessWidget {
  final Movie movie;

  const InfosTab({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.seeMoreBackground, // Set the background color to black
      child: ListView(
        children: [
          _buildInfoItem('Duration', movie.runningTime.toString()),
          _buildInfoItem('Release Date', movie.releaseDate),
          _buildInfoItem('Budget', movie.productionBudget.toString()),
          _buildInfoItem('Box Office Revenue', movie.grossRevenue.toString()),
          _buildInfoItem('Total Revenue', movie.netRevenue.toString()),
          _buildInfoItem(
              'Producers', _formatListToString(movie.productionCompanies)),
          _buildInfoItem(
              'Writers', _formatListToString(movie.screenplayAuthors)),
          _buildInfoItem('Studios', _formatListToString(movie.filmStudios)),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return ListTile(
      title: Text(title, style: TextStyle(color: Colors.white)),
      subtitle: Text(value, style: TextStyle(color: Colors.grey)),
    );
  }

  String _formatListToString(List<String> list) {
    return list.join(', ');
  }
}

Widget _buildCardItem({
  required String imageUrl,
  required String title,
  String? subtitle,
  required BuildContext context,
}) {
  return Card(
    color: AppColors.cardBackground,
    child: ListTile(
      leading: Image.network(imageUrl, fit: BoxFit.cover),
      title: Text(title, style: TextStyle(color: Colors.white)),
      subtitle: subtitle != null
          ? Text(subtitle, style: TextStyle(color: Colors.white70))
          : null,
    ),
  );
}
