import 'package:flutter/material.dart';
import 'movies_list.dart';

void main() => runApp(MovieScraper());

class MovieScraper extends StatelessWidget {
  const MovieScraper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Scraper',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MoviesList(),
    );
  }
}
