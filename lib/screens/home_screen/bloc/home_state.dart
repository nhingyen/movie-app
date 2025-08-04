import 'package:movie_app/model/movie_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<MovieModel> upcomingMovies;
  final List<MovieModel> popularMovies;
  final List<MovieModel> topRatedMovies;
  final List<MovieModel> nowPlayingMovies;

  HomeLoaded({
    required this.upcomingMovies,
    required this.popularMovies,
    required this.topRatedMovies,
    required this.nowPlayingMovies,
  });
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
