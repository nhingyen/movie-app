import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/model/movie_model.dart';
import 'package:movie_app/screens/movie_detail/bloc/movie_detail_event.dart';
import 'package:movie_app/screens/movie_detail/bloc/movie_detail_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:movie_app/services/firestore_service.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final FirestoreService firestoreService;

  MovieDetailBloc({required this.firestoreService})
    : super(MovieDetailLoading()) {
    on<LoadMovieDetailEvent>(_onLoadMovieDetail);
  }

  Future<List<MovieModel>> _fetchPopularMovies() async {
    try {
      final movies = await firestoreService.getMoviesByCategory('popular');
      if (movies.isEmpty) {
        throw Exception('Không tìm thấy phim thịnh hành trong Firestore');
      }
      return movies;
    } catch (e) {
      throw Exception('Lỗi khi tải phim thịnh hành: $e');
    }
  }

  Future<void> _onLoadMovieDetail(
    LoadMovieDetailEvent event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(MovieDetailLoading());
    try {
      // Nếu có initialMovie (Favorite/Search) thì dùng luôn movie đó
      if (event.initialMovie != null) {
        final movie = event.initialMovie!;
        final relatedMovies = await _fetchPopularMovies();

        // Lấy trailer từ TMDB theo id của movie
        String? trailerKey;
        final videoResponse = await http.get(
          Uri.parse(
            'https://api.themoviedb.org/3/movie/${movie.id}/videos?api_key=d595cdbd770bb65807690dc099be347a',
          ),
        );

        if (videoResponse.statusCode == 200) {
          final videos =
              json.decode(videoResponse.body)['results'] as List<dynamic>;
          if (videos.isNotEmpty) {
            final trailer = videos.firstWhere(
              (video) =>
                  video['type'] == 'Trailer' && video['site'] == 'YouTube',
              orElse: () => null,
            );
            trailerKey = trailer != null ? trailer['key']?.toString() : null;
          }
        }

        emit(
          MovieDetailLoaded(
            movie: movie,
            trailerKey: trailerKey,
            relatedMovies: relatedMovies,
          ),
        );
        return;
      }

      // 👉 Nếu không có initialMovie thì fetch từ Firestore
      final doc = await FirebaseFirestore.instance
          .collection("movies")
          .doc(event.movieId)
          .get();
      if (!doc.exists) {
        emit(MovieDetailError('Không tìm thấy phim trong Firestore'));
        return;
      }

      final relatedMovies = await _fetchPopularMovies();

      final movie = MovieModel.fromMap(doc.data()!);

      // Lấy trailer
      String? trailerKey;
      final videoResponse = await http.get(
        Uri.parse(
          'https://api.themoviedb.org/3/movie/${movie.id}/videos?api_key=d595cdbd770bb65807690dc099be347a',
        ),
      );

      if (videoResponse.statusCode == 200) {
        final videos =
            json.decode(videoResponse.body)['results'] as List<dynamic>;
        if (videos.isNotEmpty) {
          final trailer = videos.firstWhere(
            (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
            orElse: () => null,
          );
          trailerKey = trailer != null ? trailer['key']?.toString() : null;
        }
      }

      emit(
        MovieDetailLoaded(
          movie: movie,
          trailerKey: trailerKey,
          relatedMovies: relatedMovies,
        ),
      );
    } catch (e) {
      emit(MovieDetailError('Lỗi: $e'));
    }
  }
}
