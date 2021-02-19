import 'dart:async';

import 'package:tmdb/bloc/base_bloc.dart';
import 'package:tmdb/model/movies.dart';
import 'package:tmdb/repository/repository.dart';

class MoviesBloc implements BaseBloc {
  final _moviesListController = StreamController<List<Results>>();

  Stream<List<Results>> get moviesListStream => _moviesListController.stream;

  MovieRepository _movieRepository = MovieRepository();

  List<Results> _moviesList = List();
  List<Results> _searchResult = List();

  getMovies() async {
    Movies response = await _movieRepository.getMovies();
    _moviesList = response.results;
    _moviesListController.sink.add(_moviesList);
  }

  searchMovies(text) async {
    _searchResult.clear();
    if (text.isNotEmpty) {
      List searchTextList = text.split(' ');

      _moviesList.forEach((movie) {
        int matchedLength = 0;
        List titleSubList = movie.title.split(' ');

        for (int i = 0; i < searchTextList.length; i++) {
          for (int j = 0; j < titleSubList.length; j++) {
            if (titleSubList[j]
                .toString()
                .toLowerCase()
                .startsWith(searchTextList[i].toString().toLowerCase())) {
              matchedLength++;
              break;
            }
          }
        }
        if (matchedLength == searchTextList.length) _searchResult.add(movie);
      });
    } else if (text.isEmpty) {
      _searchResult.addAll(_moviesList);
    }
    _moviesListController.sink.add(_searchResult);
  }

  @override
  void dispose() {
    _moviesListController.close();
  }
}
