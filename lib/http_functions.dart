import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'Elements/movie.dart';
import 'Elements/genre.dart';
import 'api_key.dart' as api;

class HttpFunctions {
  final String urlBase = 'https://api.themoviedb.org/3/movie';
  final String urlPopular = '/popular?';
  final String urlLanguage = '&language=en-US';
  final String urlSearchBase =
      'https://api.themoviedb.org/3/search/movie?' + api.api_key + '&query=';
  final String urlGenreBase = 'https://api.themoviedb.org/3/discover/movie?' +
      api.api_key +
      '&with_genres=';

  final String urlGenreList = 'https://api.themoviedb.org/3/genre/movie/list?' +
      api.api_key +
      '&language=en-US';

  final String sortBy = '&sort_by=';

  final String urlGetVideo = '/videos?';

  Future<List?> getUpcoming() async {
    final String popular = urlBase + urlPopular + api.api_key + urlLanguage;
    http.Response result = await http.get(Uri.parse(popular));

    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      final moviesMap = jsonResponse['results'];
      List movies = moviesMap.map((info) => Movie.fromJson(info)).toList();
      return movies;
    } else {
      return null;
    }
  }

  Future<List?> getSearch(String title) async {
    title.replaceAll(' ', '+');
    final String query = urlSearchBase + title;
    http.Response result = await http.get(Uri.parse(query));

    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      List movies =
          jsonResponse['results'].map((info) => Movie.fromJson(info)).toList();
      return movies;
    } else {
      return null;
    }
  }

  Future<List?> getGenres() async {
    http.Response genresListResult = await http.get(Uri.parse(urlGenreList));
    if (genresListResult.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(genresListResult.body);
      final genresList = jsonResponse['genres'];
      List genres = genresList.map((info) => Genre.fromJson(info)).toList();
      return genres;
    } else {
      return null;
    }
  }

  Future<List?> findByGenre(Genre genre) async {
    final String query =
        urlGenreBase + (genre.id).toString() + sortBy + 'vote_count.desc';
    http.Response result = await http.get(Uri.parse(query));
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      final moviesByGenreList = jsonResponse['results'];
      List moviesByGenre =
          moviesByGenreList.map((info) => Movie.fromJson(info)).toList();
      return moviesByGenre;
    } else {
      return null;
    }
  }

  Future<List?> getNowPlaying() async {
    final String query = urlBase + '/now_playing?' + api.api_key;
    http.Response result = await http.get(Uri.parse(query));
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      final nowPlaying = jsonResponse['results'];
      List movies = nowPlaying.map((info) => Movie.fromJson(info)).toList();
      return movies;
    } else {
      return null;
    }
  }

  Future<String?> getMovieVideo(int id) async {
    final String query =
        urlBase + '/' + id.toString() + urlGetVideo + api.api_key;
    http.Response result = await http.get(Uri.parse(query));
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      final videosList = jsonResponse['results'];
      List videos = videosList.map((info) => info['key']).toList();
      return videos[0];
    } else {
      return null;
    }
  }

  Future<Movie?> getTopMovie() async {
    List? nowPlayingMovies;
    nowPlayingMovies = await getNowPlaying();
    if (nowPlayingMovies != null) return nowPlayingMovies[0];
  }
}
