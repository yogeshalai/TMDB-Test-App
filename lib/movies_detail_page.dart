import 'package:flutter/material.dart';
import 'package:tmdb/bloc/movies_detail_bloc.dart';
import 'package:tmdb/model/credits.dart';
import 'package:tmdb/model/similar.dart';

class MoviesDetailPage extends StatefulWidget {
  final int id;
  final String appBarTitle;

  MoviesDetailPage({this.id, this.appBarTitle});

  @override
  _MoviesDetailPageState createState() => _MoviesDetailPageState();
}

class _MoviesDetailPageState extends State<MoviesDetailPage> {
  MovieDetailBloc _movieDetailBloc = MovieDetailBloc();

  @override
  void initState() {
    super.initState();
    _movieDetailBloc.getCredits(widget.id);
    _movieDetailBloc.getSimilarMovies(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.appBarTitle)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Credits',
              style: TextStyle(fontSize: 20.0),
            ),
            getCreditWidget(),
            Text(
              'Similar Movies',
              style: TextStyle(fontSize: 20.0),
            ),
            getSimilarMoviesWidget(),
          ],
        ),
      ),
    );
  }

  Widget getCreditWidget() {
    return Container(
      height: 150,
      child: StreamBuilder<Credits>(
          stream: _movieDetailBloc.creditsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.data.cast != null &&
                snapshot.data.cast.length > 0) {
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.cast.length,
                  itemBuilder: (context, index) {
                    Cast movie = snapshot.data.cast[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          movie.profilePath != null
                              ? Container(
                                  width: 80,
                                  height: 80,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          "https://image.tmdb.org/t/p/original/" +
                                              movie.profilePath),
                                    ),
                                  ))
                              : Container(
                                  child: Icon(
                                    Icons.person,
                                    size: 80,
                                  ),
                                ),
                          Text(movie.name),
                        ],
                      ),
                    );
                  });
            } else if (snapshot.hasData &&
                snapshot.data.cast != null &&
                snapshot.data.cast.length == 0) {
              return Text("No record found");
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Widget getSimilarMoviesWidget() {
    return Container(
      height: 200,
      child: StreamBuilder<Similar>(
          stream: _movieDetailBloc.similarMoviesStream,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.data.results != null &&
                snapshot.data.results.length > 0) {
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.results.length,
                  itemBuilder: (context, index) {
                    Results movie = snapshot.data.results[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          movie.backdropPath != null
                              ? Container(
                                  width: 80,
                                  height: 120,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          "https://image.tmdb.org/t/p/original/" +
                                              movie.backdropPath),
                                    ),
                                  ))
                              : Container(
                                  child: Icon(
                                    Icons.person,
                                    size: 80,
                                  ),
                                ),
                          Container(
                            width: 80,
                            child: Text(
                              movie.title,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            } else if (snapshot.hasData &&
                snapshot.data.results != null &&
                snapshot.data.results.length == 0) {
              return Text("No record found");
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
