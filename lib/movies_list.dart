import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:movie_scraper_final/searched_movies.dart';
import 'http_functions.dart';
import 'movie_details.dart';
import 'movies_by_genre.dart';
import 'top_movie.dart';
import 'movie.dart';

class MoviesList extends StatefulWidget {
  const MoviesList({Key? key}) : super(key: key);

  @override
  _MoviesListState createState() => _MoviesListState();
}

class _MoviesListState extends State<MoviesList> {
  // TODO: Fix first load Red-Screen error

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
    initialize();
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
          title: searchBar,
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            IconButton(
              icon: visibleIcon,
              onPressed: () {
                setState(() {
                  if (visibleIcon.icon == Icons.search) {
                    visibleIcon = const Icon(Icons.cancel);
                    searchBar = TextField(
                        textInputAction: TextInputAction.search,
                        style:
                            const TextStyle(fontSize: 24, color: Colors.white),
                        onSubmitted: (String query) {
                          MaterialPageRoute route = MaterialPageRoute(
                            builder: (_) => SearchedMovies(query),
                          );
                          Navigator.push(context, route);
                        });
                  } else {
                    setState(() {
                      visibleIcon = const Icon(Icons.search);
                      searchBar = const Text('');
                    });
                  }
                });
              },
            )
          ],
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 400,
                            child: TopMovie(topMovie),
                          ),
                          Container(
                            width: 250,
                            height: 100,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            child: const Text('Popular Movies',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 144.0,
                            child: ListView.builder(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 20.0),
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics()),
                                itemCount:
                                    (moviesCount == null) ? 0 : moviesCount,
                                itemBuilder:
                                    (BuildContext context, int position) {
                                  if (movies[position].posterPath != null) {
                                    poster = NetworkImage(posterPathBase +
                                        movies[position].posterPath);
                                  } else {
                                    poster = NetworkImage(defaultPosterPath);
                                  }
                                  return Container(
                                    padding: const EdgeInsets.only(
                                      left: 8.0,
                                    ),
                                    width:
                                        MediaQuery.of(context).size.width / 3.7,
                                    child: GestureDetector(
                                      child: Card(
                                        color: Colors.transparent,
                                        child: ClipRRect(
                                          clipBehavior: Clip.hardEdge,
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          child: SizedBox.fromSize(
                                            size: Size.fromHeight(144.0),
                                            child: Image(
                                              image: poster,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        MaterialPageRoute route =
                                            MaterialPageRoute(
                                          builder: (_) =>
                                              MovieDetails(movies[position]),
                                        );
                                        Navigator.push(context, route);
                                      },
                                    ),
                                  );
                                }),
                          ),
                          SizedBox(
                            height: 3800,
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                                  (genresCount == null) ? 0 : genresCount,
                              itemBuilder:
                                  (BuildContext context, int position) {
                                return MoviesByGenre(genres[position]);
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 200,
                          ),
                        ])),
              ),
            ],
          ),
        ));
  }

  Future initialize() async {
    movies = [];
    genres = [];
    movies = (await httpFunction.getUpcoming())!;
    genres = (await httpFunction.getGenres())!;
    topMovie = (await httpFunction.getTopMovie())!;
    setState(() {
      moviesCount = movies.length;
      movies = movies;

      genresCount = genres.length;
      genres = genres;

      topMovie = topMovie;
    });
  }
}
