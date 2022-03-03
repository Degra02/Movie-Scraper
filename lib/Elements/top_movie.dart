import 'package:flutter/material.dart';
import '../movie.dart';
import '../http_functions.dart';
import 'movie_video.dart';

class TopMovie extends StatelessWidget {
  TopMovie(this.movie);

  final Movie movie;
  late String videoId;

  HttpFunctions httpFunction = HttpFunctions();

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 100,
              child: Text(movie.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            FutureBuilder(
              future: getVideoId(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return MovieVideo(videoId);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          ],
        ));
  }

  getVideoId() async {
    videoId = (await httpFunction.getMovieVideo(movie.id))!;
  }
}
