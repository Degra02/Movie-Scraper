import 'package:flutter/material.dart';
import '../movie.dart';
import '../http_functions.dart';
import '../Pages/movie_details.dart';
import 'movies_by_genre.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class MoviesList extends StatefulWidget {
  const MoviesList({Key? key}) : super(key: key);

  @override
  State<MoviesList> createState() => _MoviesListState();
}

class _MoviesListState extends State<MoviesList> {
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

  void initState() {
    httpFunction = HttpFunctions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage poster;
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            height: 100,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20.0),
            child: const Text('Popular Movies',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
          ),
          FutureBuilder(
              future: initialize(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 144.0,
                        child: ListView.builder(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 20.0),
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            itemCount: (moviesCount == null) ? 0 : moviesCount,
                            itemBuilder: (BuildContext context, int position) {
                              if (movies[position].posterPath != null) {
                                poster = NetworkImage(posterPathBase +
                                    movies[position].posterPath);
                              } else {
                                poster = NetworkImage(defaultPosterPath);
                              }
                              return AnimationConfiguration.staggeredList(
                                position: position,
                                duration: const Duration(milliseconds: 500),
                                child: SlideAnimation(
                                  horizontalOffset: 100,
                                  child: FadeInAnimation(
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                        left: 8.0,
                                      ),
                                      width: MediaQuery.of(context).size.width /
                                          3.7,
                                      child: GestureDetector(
                                        child: Card(
                                          elevation: 10,
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
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      SizedBox(
                        height: 3800,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: (genresCount == null) ? 0 : genresCount,
                          itemBuilder: (BuildContext context, int position) {
                            return MoviesByGenre(genres[position]);
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ],
      ),
    );
  }

  Future initialize() async {
    movies = [];
    genres = [];
    movies = (await httpFunction.getUpcoming())!;
    genres = (await httpFunction.getGenres())!;
    moviesCount = movies.length;
    genresCount = genres.length;
  }
}
