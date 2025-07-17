import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/api/api.dart';
import 'package:movie_app/model/movie_model.dart';
// import 'package:movie_app/model/movie_model.dart'; // Giả định có file model này

abstract class HomeEvent {}

class LoadHomeDataEvent extends HomeEvent {}

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<MovieModel> upcomingMovies;
  final List<MovieModel> popularMovies;
  final List<MovieModel> topRatedMovies;

  HomeLoaded({
    required this.upcomingMovies,
    required this.popularMovies,
    required this.topRatedMovies,
  });
}

class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final Api api =
      Api(); // Giả định Api là class chứa các phương thức getUpcomingMovies, etc.

  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final upcomingMovies = await api.getUpcomingMovies();
      final popularMovies = await api.getPopularMovies();
      final topRatedMovies = await api.getTopRatedMovies();
      emit(
        HomeLoaded(
          upcomingMovies: upcomingMovies,
          popularMovies: popularMovies,
          topRatedMovies: topRatedMovies,
        ),
      );
    } catch (e) {
      emit(HomeError(message: 'Failed to load data: $e'));
    }
  }
}
