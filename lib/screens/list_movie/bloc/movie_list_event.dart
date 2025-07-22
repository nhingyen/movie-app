abstract class MovieListEvent {
  const MovieListEvent();
}

class LoadMovieListEvent extends MovieListEvent {
  final String endpoint;

  const LoadMovieListEvent(this.endpoint);
}
