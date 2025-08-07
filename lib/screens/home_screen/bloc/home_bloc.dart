import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/screens/home_screen/bloc/home_event.dart';
import 'package:movie_app/screens/home_screen/bloc/home_state.dart';
import 'package:movie_app/services/firestore_service.dart';
// import 'package:movie_app/model/movie_model.dart'; // Giả định có file model này

// abstract class HomeEvent {}

// class LoadHomeDataEvent extends HomeEvent {}

// abstract class HomeState {}

// class HomeInitial extends HomeState {}

// class HomeLoading extends HomeState {}

// class HomeLoaded extends HomeState {
//   final List<MovieModel> upcomingMovies;
//   final List<MovieModel> popularMovies;
//   final List<MovieModel> topRatedMovies;

//   HomeLoaded({
//     required this.upcomingMovies,
//     required this.popularMovies,
//     required this.topRatedMovies,
//   });
// }

// class HomeError extends HomeState {
//   final String message;

//   HomeError({required this.message});
// }

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FirestoreService firestoreService;

  HomeBloc({required this.firestoreService}) : super(HomeInitial()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final upcomingMovies = await firestoreService.getMoviesByCategory(
        'upcoming',
      );
      final popularMovies = await firestoreService.getMoviesByCategory(
        'popular',
      );
      final topRatedMovies = await firestoreService.getMoviesByCategory(
        'top_rated',
      );
      final nowPlayingMovies = await firestoreService.getMoviesByCategory(
        'now_playing',
      );
      emit(
        HomeLoaded(
          upcomingMovies: upcomingMovies,
          popularMovies: popularMovies,
          topRatedMovies: topRatedMovies,
          nowPlayingMovies: nowPlayingMovies,
        ),
      );
    } catch (e) {
      emit(HomeError('Failed to load data: $e'));
    }
  }
}
