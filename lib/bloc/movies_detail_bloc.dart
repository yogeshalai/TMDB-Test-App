import 'dart:async';

import 'package:tmdb/bloc/base_bloc.dart';
import 'package:tmdb/model/credits.dart';
import 'package:tmdb/model/similar.dart';
import 'package:tmdb/repository/repository.dart';

class MovieDetailBloc implements BaseBloc {

  MovieRepository _movieRepository = MovieRepository();

  final _creditsController = StreamController<Credits>();

  Stream<Credits> get creditsStream => _creditsController.stream;

  final _similarMoviesController = StreamController<Similar>();

  Stream<Similar> get similarMoviesStream => _similarMoviesController.stream;

  getCredits(id) async {
    Credits response = await _movieRepository.getCredits(id);
    _creditsController.sink.add(response);
  }

  getSimilarMovies(id) async {
    Similar response = await _movieRepository.getSimilarMovies(id);
    _similarMoviesController.sink.add(response);
  }

  @override
  void dispose() {
    _creditsController.close();
    _similarMoviesController.close();
  }
}
