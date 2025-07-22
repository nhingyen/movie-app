import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/api/constant.dart';
import 'package:movie_app/model/movie_model.dart';
import 'package:movie_app/screens/movie_detail/bloc/movie_detail_event.dart';
import 'package:movie_app/screens/movie_detail/bloc/movie_detail_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  MovieDetailBloc() : super(MovieDetailLoading()) {
    on<LoadMovieDetailEvent>(_onLoadMovieDetail);
  }

  Future<void> _onLoadMovieDetail(
    LoadMovieDetailEvent event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(MovieDetailLoading());
    try {
      final movieResponse = await http.get(
        Uri.parse(
          'https://api.themoviedb.org/3/movie/${event.movieId}?api_key=$apiKey&language=vi-VN',
        ),
      );
      print(
        'API RESPONSE: ${movieResponse.statusCode} - ${movieResponse.body}',
      );
      if (movieResponse.statusCode != 200) {
        emit(const MovieDetailError('Lỗi khi tải chi tiết phim'));
        return;
      }
      final movieData = json.decode(movieResponse.body);
      final movie = MovieModel.fromMap(movieData);

      String? trailerKey;
      final videoResponse = await http.get(
        Uri.parse(
          'https://api.themoviedb.org/3/movie/${event.movieId}/videos?api_key=$apiKey',
        ),
      );
      print(
        'Video API response: ${videoResponse.statusCode} - ${videoResponse.body}',
      );
      if (videoResponse.statusCode == 200) {
        final videos =
            json.decode(videoResponse.body)['results'] as List<dynamic>;
        if (videos.isNotEmpty) {
          final trailer = videos.firstWhere(
            (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
            orElse: () => null,
          );
          trailerKey = trailer?['key'];
          print('Trailer key: $trailerKey');
        } else {
          print('No videos found for movie ID: ${event.movieId}');
        }
      } else {
        print('Failed to load videos: ${videoResponse.statusCode}');
      }
      emit(MovieDetailLoaded(movie, trailerKey));
      print('State emitted: MovieDetailLoaded');
    } catch (e) {
      emit(MovieDetailError('Lỗi: $e'));
      print('Error occurred: $e');
    }
  }
}
