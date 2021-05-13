import 'package:flutter/material.dart';
import 'package:netflix_clone/movie_row.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netflix Clone',
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.white,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final Map<String, String> _categories = {
    'NETFLIX ORIGINALS': 'originals',
    'Trending Now': 'trending',
    'Top Rated': 'toprated',
    'Action Movies': 'action',
    'Comedy Movies': 'comedy',
    'Horror Movies': 'horror',
    // 'Romance Movies': 'romance',
    'Documentaries': 'documentaries',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Image.asset('assets/images/netflix.png'),
          height: 90,
          width: 100,
          padding: EdgeInsets.only(top: 3.0),
          margin: EdgeInsets.all(0),
        ),
        actions: [
          IconButton(
              icon: Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/0/0b/Netflix-avatar.png',
              ),
              onPressed: () {}),
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.builder(
        itemBuilder: (ctx, i) => MovieRow(
          title: _categories.keys.toList()[i],
          categoryUrl: _categories[_categories.keys.toList()[i]],
          isLarge: _categories.keys.toList()[i] == 'NETFLIX ORIGINALS',
        ),
        itemCount: _categories.keys.toList().length,
      ),
    );
  }
}
