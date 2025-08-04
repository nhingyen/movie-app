import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/model/movie_model.dart';
import 'package:movie_app/screens/list_movie/bloc/movie_list_event.dart';
import 'package:movie_app/screens/list_movie/bloc/movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  MovieListBloc() : super(MovieListLoading()) {
    on<LoadMovieListEvent>(_onLoadMovieList);
  }

  Future<void> _onLoadMovieList(
    LoadMovieListEvent event,
    Emitter<MovieListState> emit,
  ) async {
    emit(MovieListLoading());
    try {
      final snapshot = await _firestore
          .collection('movies')
          .where('endpoint', isEqualTo: event.endpoint)
          .get();

      final movies = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Gắn ID Firestore
        return MovieModel.fromMap(data);
      }).toList();

      emit(MovieListLoaded(movies));
    } catch (e) {
      emit(MovieListError('Lỗi khi lấy phim từ Firestore: $e'));
    }
  }
}
