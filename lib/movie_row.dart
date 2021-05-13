import 'dart:convert';
import 'dart:math';
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
                desc: movie['overview'],
                posterPath: 'https://image.tmdb.org/t/p/original' +
                    movie['poster_path'],
                backdropPath: 'https://image.tmdb.org/t/p/original' +
                    movie['backdrop_path'])),
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
    var idx = Random().nextInt(10);
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
                  if (widget.isLarge)
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 300,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Image.network(
                              snapshot.data[idx].posterPath,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10, bottom: 20),
                          height: 300,
                          width: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data[idx].name,
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                snapshot.data[idx].desc
                                    .substring(0, 100),
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 14,
                                ),
                                softWrap: true,
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.black45),
                                    onPressed: () {},
                                    child: Text(
                                      'Play',
                                      style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.black45),
                                    onPressed: () {},
                                    child: Text(
                                      'My List',
                                      style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                    height: widget.isLarge ? 250 : 150,
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
