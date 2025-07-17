import 'dart:convert';

import 'package:movie_app/api/constant.dart';
import 'package:movie_app/model/movie_model.dart';
import 'package:http/http.dart' as http;

class Api {
  final upComingApiUrl =
      "https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey&language=vi";
  final popularApiUrl =
      "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=vi";
  final topRateApiUrl =
      "https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey&language=vi";

  Future<List<MovieModel>> getUpcomingMovies() async {
    final response = await http.get(Uri.parse(upComingApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<MovieModel> movies = data
          .map((movie) => MovieModel.fromMap(movie as Map<String, dynamic>))
          .toList();
      return movies;
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

  Future<List<MovieModel>> getPopularMovies() async {
    final response = await http.get(Uri.parse(popularApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<MovieModel> movies = data
          .map((movie) => MovieModel.fromMap(movie as Map<String, dynamic>))
          .toList();
      return movies;
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<List<MovieModel>> getTopRatedMovies() async {
    final response = await http.get(Uri.parse(topRateApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<MovieModel> movies = data
          .map((movie) => MovieModel.fromMap(movie as Map<String, dynamic>))
          .toList();
      return movies;
    } else {
      throw Exception('Failed to load popular movies');
    }
  }
}
