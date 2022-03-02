import 'package:flutter/material.dart';
import 'genre.dart';
import 'movie.dart';
import 'movie_details.dart';
import 'http_functions.dart';

class MoviesByGenre extends StatefulWidget {
  MoviesByGenre(
    this.genre,
  );

  final Genre genre;

  @override
  _MoviesByGenreState createState() => _MoviesByGenreState();
}

class _MoviesByGenreState extends State<MoviesByGenre> {
  final String posterPathBase = 'https://image.tmdb.org/t/p/w185/';
  final String defaultPosterPath =
      'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';

  late HttpFunctions httpFunction;
  int? moviesCount;
  late List movies;

  @override
  void initState() {
    httpFunction = HttpFunctions();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage poster;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 250,
          height: 80,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20, top: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(widget.genre.name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 144.0,
          child: ListView.builder(
              padding: const EdgeInsets.only(left: 10.0, right: 20.0),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemCount: (moviesCount == null) ? 0 : moviesCount,
              itemBuilder: (BuildContext context, int position) {
                if (movies[position].posterPath != null) {
                  poster = NetworkImage(
                      posterPathBase + movies[position].posterPath);
                } else {
                  poster = NetworkImage(defaultPosterPath);
                }
                return Container(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                  ),
                  width: MediaQuery.of(context).size.width / 3.7,
                  child: GestureDetector(
                    child: Card(
                      color: Colors.transparent,
                      child: ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox.fromSize(
                          size: Size.fromHeight(144.0),
                          child: Image(
                            image: poster,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      MaterialPageRoute route = MaterialPageRoute(
                        builder: (_) => MovieDetails(movies[position]),
                      );
                      Navigator.push(context, route);
                    },
                  ),
                );
              }),
        ),
      ],
    );
  }

  Future initialize() async {
    movies = [];
    movies = (await httpFunction.findByGenre(widget.genre))!;
    setState(() {
      moviesCount = movies.length;
      movies = movies;
    });
  }
}
