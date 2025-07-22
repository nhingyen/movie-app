import 'package:movie_app/model/movie_model.dart';

abstract class MovieDetailState {
  const MovieDetailState();
}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailLoaded extends MovieDetailState {
  final MovieModel movie;
  final String? trailerKey;

  const MovieDetailLoaded(this.movie, this.trailerKey);
}

class MovieDetailError extends MovieDetailState {
  final String message;

  const MovieDetailError(this.message);
}
