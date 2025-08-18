import 'package:movie_app/model/movie_model.dart';

abstract class MovieDetailEvent {
  const MovieDetailEvent();
}

class LoadMovieDetailEvent extends MovieDetailEvent {
  final String movieId;
  final MovieModel? initialMovie;

  const LoadMovieDetailEvent(this.movieId, {this.initialMovie});
}
