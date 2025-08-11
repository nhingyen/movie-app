import 'package:equatable/equatable.dart';
import 'package:movie_app/model/movie_model.dart';

abstract class MovieDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailError extends MovieDetailState {
  final String message;

  MovieDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieDetailLoaded extends MovieDetailState {
  final MovieModel movie;
  final String? trailerKey;
  final List<MovieModel> relatedMovies;

  MovieDetailLoaded({
    required this.movie,
    this.trailerKey,
    required this.relatedMovies,
  });

  @override
  List<Object?> get props => [movie, trailerKey, relatedMovies];
}
