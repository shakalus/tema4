// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        scaffoldBackgroundColor: Colors.lightBlue,
      ),
      home: const MyHomePage(title: 'Movies'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _titles = <String>[];
  final List<String> _images = <String>[];
  final List<String> _genres = <String>[];
  final List<String> _years = <String>[];
  final List<String> _runtime = <String>[];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getMovies();
  }

  void _getMovies() {
    get(Uri.parse('https://yts.mx/api/v2/list_movies.json')).then((Response response) {
      response.body;
      final Map<String, dynamic> map = jsonDecode(response.body) as Map<String, dynamic>;
      final Map<String, dynamic> data = map['data'] as Map<String, dynamic>;
      final List<Map<dynamic, dynamic>> movies = List<Map<dynamic, dynamic>>.from(data['movies'] as List<dynamic>);
      for (int i = 0; i < movies.length; i++) {
        final Map<dynamic, dynamic> movie = movies[i];
        _genres.add(movie['genres'].join(' / ') as String);
      }
      for (final Map<dynamic, dynamic> item in movies) {
        _titles.add(item['title'] as String);
        _images.add(item['medium_cover_image'] as String);
        _years.add(item['year'].toString());
        _runtime.add(item['runtime'].toString());
      }

      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 30,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const <Widget>[
                  Text(
                    'Now Showing',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Coming Soon',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Top Rated',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Popular',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            Builder(
              builder: (BuildContext context) {
                if (_isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                } else {
                  return Expanded(
                    child: PageView.builder(
                      itemCount: _titles.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String title = _titles[index];
                        final String image = _images[index];
                        final String genre = _genres[index];
                        final String year = _years[index];
                        final String runtime = _runtime[index];

                        return Column(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              width: MediaQuery.of(context).size.width * 0.8,
                              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35),
                                image: DecorationImage(
                                  image: NetworkImage(image),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            ListTile(
                              title: Center(
                                child: Text(
                                  title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              subtitle: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Text(
                                  '$genre $runtime minutes $year ',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
