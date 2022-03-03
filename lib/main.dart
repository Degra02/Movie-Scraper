import 'package:flutter/material.dart';
import 'Pages/homepage.dart';

void main() => runApp(MovieScraper());

class MovieScraper extends StatelessWidget {
  const MovieScraper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Scraper',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}
