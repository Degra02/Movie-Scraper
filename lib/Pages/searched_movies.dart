import 'package:flutter/material.dart';
import '../http_functions.dart';
import 'movie_details.dart';

class SearchedMovies extends StatefulWidget {
  SearchedMovies(this.searched);

  final String searched;

  @override
  _SearchedMoviesState createState() => _SearchedMoviesState();
}

class _SearchedMoviesState extends State<SearchedMovies> {
  late HttpFunctions httpFunctions;
  late List searchedMovies;
  late int listLength;
  final String posterPathBase = 'https://image.tmdb.org/t/p/w185/';
  final String defaultPosterPath =
      'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';

  @override
  void initState() {
    httpFunctions = HttpFunctions();
    initialize(widget.searched);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage poster;
    return Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: searchedMovies.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, int position) {
                if (searchedMovies[position].posterPath != null) {
                  poster = NetworkImage(
                      posterPathBase + searchedMovies[position].posterPath);
                } else {
                  poster = NetworkImage(defaultPosterPath);
                }
                return Column(
                  children: [
                    Container(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withAlpha(20),
                            Colors.white.withAlpha(5),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
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
                                    size: const Size.fromHeight(120.0),
                                    child: Image(
                                      image: poster,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                MaterialPageRoute route = MaterialPageRoute(
                                  builder: (_) =>
                                      MovieDetails(searchedMovies[position]),
                                );
                                Navigator.push(context, route);
                              },
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                    child: Text(
                                  searchedMovies[position].title,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )),
                                Container(
                                  height: 50,
                                  child: Text(
                                    searchedMovies[position].overview,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
        ));
  }

  Future initialize(String query) async {
    searchedMovies = [];
    searchedMovies = (await httpFunctions.getSearch(query))!;
    setState(() {
      listLength = searchedMovies.length;
      searchedMovies = searchedMovies;
    });
  }
}
