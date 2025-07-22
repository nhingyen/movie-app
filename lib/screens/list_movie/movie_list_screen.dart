import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/screens/list_movie/bloc/movie_list_bloc.dart';
import 'package:movie_app/screens/list_movie/bloc/movie_list_event.dart';
import 'package:movie_app/screens/list_movie/bloc/movie_list_state.dart';
import 'package:movie_app/screens/movie_detail/movie_detail_screen.dart';

class MovieListScreen extends StatelessWidget {
  final String title;
  final String endpoint;

  const MovieListScreen({
    super.key,
    required this.title,
    required this.endpoint,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieListBloc()..add(LoadMovieListEvent(endpoint)),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(31, 43, 42, 42),
        appBar: AppBar(
          title: Text(title),
          backgroundColor: const Color.fromARGB(31, 43, 42, 42),
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<MovieListBloc, MovieListState>(
          builder: (context, state) {
            if (state is MovieListLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is MovieListError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else if (state is MovieListLoaded) {
              final movies = state.movies;
              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 10,
                ),
                itemCount: (movies.length / 3).ceil(),
                itemBuilder: (context, index) {
                  final startIndex = index * 3;
                  final endIndex = (startIndex + 3).clamp(0, movies.length);
                  final rowMovies = movies.sublist(startIndex, endIndex);

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: rowMovies.map((movie) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetailScreen(movie: movie),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                "https://image.tmdb.org/t/p/original/${movie.backdropPath ?? ''}",
                                height: 170,
                                width: 110,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Text(
                                      'Lỗi tải hình ảnh',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 95,
                                    child: Center(
                                      child: Text(
                                        movie.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      'Rating: ${movie.voteAverage.toStringAsFixed(1)}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              );
            }
            return const Center(
              child: Text(
                'Không có dữ liệu',
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }
}
