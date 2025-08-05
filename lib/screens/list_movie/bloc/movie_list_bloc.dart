import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/model/movie_model.dart';
import 'package:movie_app/screens/list_movie/bloc/movie_list_event.dart';
import 'package:movie_app/screens/list_movie/bloc/movie_list_state.dart';
import 'package:movie_app/services/firestore_service.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final FirestoreService firestoreService;

  MovieListBloc({required this.firestoreService}) : super(MovieListInitial()) {
    on<LoadMovieListEvent>(_onLoadMovieList);
  }

  Future<void> _onLoadMovieList(
    LoadMovieListEvent event,
    Emitter<MovieListState> emit,
  ) async {
    emit(MovieListLoading());
    try {
      List<MovieModel> movies = [];
      if (event.endpoint == 'all_categories') {
        // Lấy phim từ 4 danh mục
        final categories = ['now_playing', 'top_rated', 'popular', 'upcoming'];
        for (final category in categories) {
          final categoryMovies = await firestoreService.getMoviesByCategory(
            category,
          );
          movies.addAll(categoryMovies);
        }
        // Loại bỏ trùng lặp dựa trên ID
        final uniqueMovies = movies
            .asMap()
            .entries
            .fold<Map<String, MovieModel>>({}, (map, entry) {
              map[entry.value.id] = entry.value;
              return map;
            })
            .values
            .toList();
        // Sắp xếp theo timestamp (nếu cần)
        uniqueMovies.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));
        if (uniqueMovies.isEmpty) {
          emit(const MovieListError('Không tìm thấy phim cho danh mục này'));
        } else {
          emit(MovieListLoaded(uniqueMovies));
        }
      } else {
        // Xử lý endpoint là một danh mục cụ thể
        final category = event.endpoint.split('/').last;
        final movies = await firestoreService.getMoviesByCategory(category);
        if (movies.isEmpty) {
          emit(const MovieListError('Không tìm thấy phim cho danh mục này'));
        } else {
          emit(MovieListLoaded(movies));
        }
      }
    } catch (e) {
      emit(MovieListError('Lỗi khi lấy phim từ Firestore: $e'));
    }
  }
}
