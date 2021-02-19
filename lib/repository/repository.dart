import 'package:dio/dio.dart';
import 'package:tmdb/model/credits.dart';
import 'package:tmdb/model/movies.dart';
import 'package:tmdb/model/similar.dart';

class MovieRepository {
  static String baseURL = "https://api.themoviedb.org/3";
  final String apiKey = "ab4e29f83528d115c211755ec12516f6";
  final Dio _dio = Dio();
  var getPopularUrl = '$baseURL/movie/top_rated';
  var movieUrl = "$baseURL/movie";

  Future<Movies> getMovies() async {
    var data = {"api_key": apiKey};
    Response response = await _dio.get(getPopularUrl, queryParameters: data);
    print(response.statusCode);
    return Movies.fromJson(response.data);
  }

  Future<Similar> getSimilarMovies(id) async {
    var data = {"api_key": apiKey};
    Response response = await _dio.get('$movieUrl/$id/similar', queryParameters: data);
    print(response.statusCode);
    return Similar.fromJson(response.data);
  }

  Future<Credits> getCredits(id) async {
    var data = {"api_key": apiKey};
    Response response = await _dio.get('$movieUrl/$id/credits', queryParameters: data);
    print(response.statusCode);
    return Credits.fromJson(response.data);
  }
}
