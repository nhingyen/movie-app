abstract class MovieDetailEvent {
  const MovieDetailEvent();
}

class LoadMovieDetailEvent extends MovieDetailEvent {
  final String movieId;

  const LoadMovieDetailEvent(this.movieId);
}
