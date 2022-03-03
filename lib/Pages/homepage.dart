import 'package:flutter/material.dart';
import 'package:movie_scraper_final/Pages/searched_movies.dart';
import '../http_functions.dart';
import '../Elements/top_movie.dart';
import '../Elements/movie.dart';
import '../Elements/movies_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HttpFunctions httpFunction;
  int? moviesCount;
  late List movies;
  late List searchedMovies;
  late Movie topMovie;
  late int genresCount; // int genresCount = 19;
  late List genres;

  final String posterPathBase = 'https://image.tmdb.org/t/p/w185/';
  final String defaultPosterPath =
      'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';

  Icon visibleIcon = const Icon(Icons.search);
  Widget searchBar = const Text('');

  @override
  void initState() {
    httpFunction = HttpFunctions();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage poster;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration.collapsed(
              hintStyle:
                  TextStyle(color: Colors.white.withAlpha(100), fontSize: 20),
              hintText: 'Search',
            ),
            style: const TextStyle(color: Colors.white, fontSize: 20),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.search,
            showCursor: false,
            autofocus: false,
            onSubmitted: (String query) {
              MaterialPageRoute route =
                  MaterialPageRoute(builder: (_) => SearchedMovies(query));
              Navigator.push(context, route);
            },
          ),
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            child: FutureBuilder(
              future: initTopMovie(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 400,
                          child: TopMovie(topMovie),
                        ),
                        Container(height: 5000, child: MoviesList()),
                      ]);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ));
  }

  Future initTopMovie() async {
    topMovie = (await httpFunction.getTopMovie())!;
  }
}
