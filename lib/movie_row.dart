import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './models/movie.dart';

class MovieRow extends StatefulWidget {
  final String title;
  final String categoryUrl;
  final bool isLarge;

  MovieRow({this.title, this.categoryUrl, this.isLarge});

  @override
  _MovieRowState createState() => _MovieRowState();
}

class _MovieRowState extends State<MovieRow> {
  Future<List<Movie>> movies;

  Future<List<Movie>> fetchMovies() async {
    final baseUrl =
        'https://netflix-clone-web-app.herokuapp.com/' + widget.categoryUrl;
    try {
      final url = Uri.parse(baseUrl);
      final response = await http.get(url);
      final data = json.decode(response.body);
      List<Movie> extractedMovies = [];
      data.forEach((movie) => {
            extractedMovies.add(Movie(
                id: movie['id'],
                name: movie['name'] != null
                    ? movie['name']
                    : movie['original_name'] != null
                        ? movie['original_name']
                        : movie['title'],
                posterPath: 'https://image.tmdb.org/t/p/original' +
                    movie['poster_path'],
                backdropPath: 'https://image.tmdb.org/t/p/original' +
                    movie['backdrop_path']))
          });
      return extractedMovies;
    } catch (error) {
      throw error;
    }
  }

  @override
  void initState() {
    super.initState();
    movies = fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
        future: movies,
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            // print(snapshot.data);
            return Container(
              color: Theme.of(context).primaryColor,
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.all(30),
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    height: widget.isLarge ? 300 : 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data
                          .map((e) => Image.network(
                                widget.isLarge ? e.posterPath : e.backdropPath,
                                fit: BoxFit.cover,
                              ))
                          .toList(),
                    ),
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                ],
              ),
              padding: EdgeInsets.all(10),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          return Center(child: CircularProgressIndicator());
        });
  }
}
