import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/api/constant.dart';
import 'dart:convert';
import 'package:movie_app/model/movie_model.dart';
import 'package:movie_app/screens/list_movie/bloc/movie_list_event.dart';
import 'package:movie_app/screens/list_movie/bloc/movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  MovieListBloc() : super(MovieListLoading()) {
    on<LoadMovieListEvent>(_onLoadMovieList);
  }

  Future<void> _onLoadMovieList(
    LoadMovieListEvent event,
    Emitter<MovieListState> emit,
  ) async {
    emit(MovieListLoading());
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.themoviedb.org/3/${event.endpoint}?api_key=$apiKey&language=vi-VN',
        ),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final movies = (data['results'] as List<dynamic>)
            .map((movie) => MovieModel.fromMap(movie))
            .toList();
        emit(MovieListLoaded(movies));
      } else {
        emit(const MovieListError('Lỗi khi tải danh sách phim'));
      }
    } catch (e) {
      emit(MovieListError('Lỗi: $e'));
    }
  }
}
