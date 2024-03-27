import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../models_api/comics_model.dart';
import '../../couleurs/couleurs.dart';

class ComicsDetailsScreen extends StatefulWidget {
  final Comic comics;

  const ComicsDetailsScreen({Key? key, required this.comics}) : super(key: key);

  @override
  State<ComicsDetailsScreen> createState() => _ComicsDetailsScreenState();
}

class _ComicsDetailsScreenState extends State<ComicsDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Widget _buildSeriesImage() {
    return Row(
      children: [
        Image.network(
          widget.comics.coverImageUrl,
          width: 100,
          fit: BoxFit.cover,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.comics.issueNumber} tomes',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Sortie: ${widget.comics.publicationDate}',
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
              widget.comics.coverImageUrl,
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
              title: Text(widget.comics.title,
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
                    child: _buildSeriesImage(),
                  ),
                  _buildTabBar(),
                  Container(
                    height: MediaQuery.of(context).size.height -
                        kToolbarHeight -
                        MediaQuery.of(context).padding.top,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        HistoryTab(comics: widget.comics),
                        CharactersTab(comics: widget.comics),
                        AuthorsTab(comics: widget.comics),
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
        Tab(text: 'Histoire'),
        Tab(text: 'Personnages'),
        Tab(text: 'Auteurs'),
      ],
    );
  }
}

class HistoryTab extends StatelessWidget {
  final Comic comics;

  const HistoryTab({Key? key, required this.comics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.seeMoreBackground, // Set the background color to black
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: HtmlWidget(
          comics.summary,
          textStyle: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class CharactersTab extends StatelessWidget {
  final Comic comics;

  const CharactersTab({Key? key, required this.comics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          AppColors.seeMoreBackground, // Ensure this is defined in your theme
      child: ListView.builder(
        itemCount: comics.title.length,
        itemBuilder: (context, index) {
          final character = comics.title[index];
        },
      ),
    );
  }
}

class AuthorsTab extends StatelessWidget {
  final Comic comics;

  const AuthorsTab({Key? key, required this.comics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          AppColors.seeMoreBackground, // Ensure this is defined in your theme
      child: ListView.builder(
        itemCount: comics.title.length,
        itemBuilder: (context, index) {
          final person = comics.title[index];
        },
      ),
    );
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
