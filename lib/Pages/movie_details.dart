import 'package:flutter/material.dart';
import '../Elements/movie.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Elements/movie_video.dart';
import '../http_functions.dart';

class MovieDetails extends StatelessWidget {
  MovieDetails(this.movie);

  late HttpFunctions httpFunction = HttpFunctions();
  final Movie movie;
  final String posterPathBase = 'https://image.tmdb.org/t/p/original/';
  final TextStyle overviewStyle = const TextStyle(
    color: Colors.white,
    fontSize: 20,
  );
  final TextStyle titleStyle = const TextStyle(
    color: Colors.white,
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  late String videoId;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    NetworkImage poster = NetworkImage(posterPathBase + movie.posterPath);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                children: [
                  Container(
                    height: 200,
                    child: Center(
                      child: Text(movie.title,
                          style: GoogleFonts.roboto(textStyle: titleStyle)),
                    ),
                  ),
                  FutureBuilder(
                    future: getVideoId(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return (videoId != null)
                            ? MovieVideo(videoId)
                            : Center(
                                child: CircularProgressIndicator(),
                              ); //MovieVideo(id);
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: height / 4,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Release Date:  ' + movie.releaseDate,
                      style: GoogleFonts.roboto(textStyle: overviewStyle),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Rating:  ' + movie.voteAverage.toString(),
                      style: GoogleFonts.roboto(textStyle: overviewStyle),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      movie.overview,
                      style: GoogleFonts.manrope(textStyle: overviewStyle),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getVideoId() async {
    videoId = (await httpFunction.getMovieVideo(movie.id))!;
  }
}
