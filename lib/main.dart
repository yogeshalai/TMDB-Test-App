import 'package:flutter/material.dart';
import 'package:tmdb/bloc/movies_bloc.dart';
import 'package:tmdb/model/movies.dart';
import 'package:tmdb/movies_detail_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MoviesListPage(),
    );
  }
}

class MoviesListPage extends StatefulWidget {
  @override
  _MoviesListPageState createState() => _MoviesListPageState();
}

class _MoviesListPageState extends State<MoviesListPage> {
  Widget appBarTitle = new Text("Movies");
  Icon actionIcon = new Icon(Icons.search);
  MoviesBloc _moviesBloc = MoviesBloc();

  @override
  void initState() {
    super.initState();
    _moviesBloc.getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: appBarTitle, actions: <Widget>[
        new IconButton(
          icon: actionIcon,
          onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = new Icon(Icons.close);
                this.appBarTitle = new TextField(
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                  onChanged: (value) {
                    onSearchTextChanged(value);
                  },
                  decoration: new InputDecoration(
                      prefixIcon: new Icon(Icons.search, color: Colors.white),
                      hintText: "Search...",
                      hintStyle: new TextStyle(color: Colors.white)),
                );
              } else {
                this.actionIcon = new Icon(Icons.search);
                this.appBarTitle = new Text("Movies");
                onSearchTextChanged("");
              }
            });
          },
        ),
      ]),
      body: StreamBuilder<List<Results>>(
        stream: _moviesBloc.moviesListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            return ListView.separated(
                itemCount: snapshot.data.length,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(height: 1, color: Colors.grey),
                itemBuilder: (context, index) {
                  Results movie = snapshot.data[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MoviesDetailPage(
                                      id: movie.genreIds[0],
                                  appBarTitle: movie.title,
                                    )));
                      },
                      leading: Container(
                          width: 80,
                          height: 80,
                          decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  "https://image.tmdb.org/t/p/original/" +
                                      movie.backdropPath),
                            ),
                          )),
                      title: Text(movie.title),
                      subtitle: Text(movie.releaseDate),
                    ),
                  );
                });
          } else if (snapshot.hasData && snapshot.data.length == 0) {
            return Center(child: Text("No record found"));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _moviesBloc.searchMovies(text);
  }
}
