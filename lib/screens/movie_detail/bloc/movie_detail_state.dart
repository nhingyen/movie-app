import 'package:movie_app/model/movie_model.dart';

abstract class MovieDetailState {
  const MovieDetailState();
}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailLoaded extends MovieDetailState {
  final MovieModel movie;
  final String? youtubeKey;
  final List<MovieModel> relatedMovies;

  const MovieDetailLoaded({
    required this.movie,
    this.youtubeKey,
    required this.relatedMovies,
  });
}

class MovieDetailError extends MovieDetailState {
  final String message;

  const MovieDetailError(this.message);
}
