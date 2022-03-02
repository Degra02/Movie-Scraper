class Movie {
  late String title;
  late int id;
  late double voteAverage;
  late String releaseDate;
  late String overview;
  late String posterPath;

  Movie(this.title, this.id, this.voteAverage, this.releaseDate, this.overview,
      this.posterPath);

  Movie.fromJson(Map<String, dynamic> parsedJson) {
    title = parsedJson["title"];
    id = parsedJson["id"];
    voteAverage = parsedJson["vote_average"] * 1.0;
    releaseDate = parsedJson["release_date"];
    overview = parsedJson["overview"];
    posterPath = parsedJson["poster_path"];
  }
}
