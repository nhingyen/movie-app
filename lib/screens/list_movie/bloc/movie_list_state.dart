import 'package:movie_app/model/movie_model.dart';

abstract class MovieListState {
  const MovieListState();
}

class MovieListInitial extends MovieListState {}

class MovieListLoading extends MovieListState {}

class MovieListLoaded extends MovieListState {
  final List<MovieModel> movies;

  const MovieListLoaded(this.movies);
}

class MovieListError extends MovieListState {
  final String message;

  const MovieListError(this.message);
}
