import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/screens/home_screen/bloc/home_bloc.dart';
import 'package:movie_app/screens/home_screen/bloc/home_event.dart';
import 'package:movie_app/screens/home_screen/bloc/home_state.dart';
import 'package:movie_app/screens/list_movie/movie_list_screen.dart';
import 'package:movie_app/screens/movie_detail/movie_detail_screen.dart';
import 'package:movie_app/services/firestore_service.dart';
import 'package:movie_app/widgets/carousel_home.dart';
import 'package:movie_app/widgets/footer/footer_home.dart';
import 'package:movie_app/widgets/header_home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeBloc(firestoreService: FirestoreService())
            ..add(LoadHomeDataEvent()),
      child: const HomeScreenContent(),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(31, 43, 42, 42),
      body: Column(
        children: [
          CustomHeader(),
          Expanded(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is HomeError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                } else if (state is HomeLoaded) {
                  final upcomingMovies = state.upcomingMovies;
                  final popularMovies = state.popularMovies;
                  final topRatedMovies = state.topRatedMovies;
                  final nowPlayingMovies = state.nowPlayingMovies;
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const Text(
                          //   'Phim Mới Ra Mắt',
                          //   style: TextStyle(color: Colors.white, fontSize: 18),
                          // ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              children: [
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeScreen(),
                                      ),
                                    );
                                  },
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(color: Colors.white),
                                  ),
                                  child: Text(
                                    'Đề xuất',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 7),
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MovieListScreen(
                                          title: 'Phim bộ',
                                          endpoint: 'all_categories',
                                        ),
                                      ),
                                    );
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(color: Colors.white),
                                  ),
                                  child: Text(
                                    'Phim bộ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                // SizedBox(width: 7),
                                // MaterialButton(
                                //   onPressed: () {},
                                //   shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(20),
                                //     side: BorderSide(color: Colors.white),
                                //   ),
                                //   child: Text(
                                //     'TV Shows',
                                //     style: TextStyle(
                                //       color: Colors.white,
                                //       fontSize: 13,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (upcomingMovies.isNotEmpty)
                            HomeCarousel(movies: upcomingMovies)
                          else
                            const Center(
                              child: Text(
                                'Không có phim nào',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                'Phim Thịnh Hành',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieListScreen(
                                        title: 'Phim Thịnh Hành',
                                        endpoint: 'popular',
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.navigate_next,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                padding: EdgeInsets
                                    .zero, // ← Bỏ padding mặc định của IconButton
                                constraints: BoxConstraints(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (popularMovies.isNotEmpty)
                            SizedBox(
                              height: 235, // Chiều cao cố định để chứa các item
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal, // Cuộn ngang
                                itemCount: min(7, popularMovies.length),
                                itemBuilder: (context, index) {
                                  final movie = popularMovies[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MovieDetailScreen(
                                                movieId: movie.id,
                                              ),
                                        ),
                                      );
                                    },
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MovieDetailScreen(
                                                  movieId: movie.id,
                                                ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 145,
                                        margin: const EdgeInsets.only(
                                          right: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF292B37),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15),
                                              ),
                                              child: Image.network(
                                                "https://image.tmdb.org/t/p/w500${movie.backdropPath ?? ''}",
                                                height: 180,
                                                width: 150,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return const Center(
                                                        child: Text(
                                                          'Lỗi tải hình ảnh',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 5,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child: Text(
                                                      movie.title,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
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
                                                  // SizedBox(height: 5),
                                                  // Text(
                                                  //   'Release: ${movie.releaseDate}',
                                                  //   style: const TextStyle(
                                                  //     color: Colors.white70,
                                                  //     fontSize: 14,
                                                  //   ),
                                                  // ),
                                                  // SizedBox(height: 5),
                                                ],
                                              ),
                                            ), // Thêm padding để tránh lỗi
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                'Phim Nổi Bật',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieListScreen(
                                        title: 'Phim Nổi Bật',
                                        endpoint: 'top_rated',
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.navigate_next,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                padding: EdgeInsets
                                    .zero, // ← Bỏ padding mặc định của IconButton
                                constraints: BoxConstraints(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (topRatedMovies.isNotEmpty)
                            SizedBox(
                              height: 235, // Chiều cao cố định để chứa các item
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal, // Cuộn ngang
                                itemCount: min(7, topRatedMovies.length),
                                itemBuilder: (context, index) {
                                  final movie = topRatedMovies[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MovieDetailScreen(
                                                movieId: movie.id,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 145,
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF292B37),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                            ),
                                            child: Image.network(
                                              "https://image.tmdb.org/t/p/w500${movie.backdropPath ?? ''}",
                                              height: 180,
                                              width: 150,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return const Center(
                                                      child: Text(
                                                        'Lỗi tải hình ảnh',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    movie.title,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
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
                                                // SizedBox(height: 5),
                                                // Text(
                                                //   'Release: ${movie.releaseDate}',
                                                //   style: const TextStyle(
                                                //     color: Colors.white70,
                                                //     fontSize: 14,
                                                //   ),
                                                // ),
                                                // SizedBox(height: 5),
                                              ],
                                            ),
                                          ), // Thêm padding để tránh lỗi
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                'Phim Mới Ra Mắt',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieListScreen(
                                        title: 'Phim Mới Ra Mắt',
                                        endpoint: 'now_playing',
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.navigate_next,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                padding: EdgeInsets
                                    .zero, // ← Bỏ padding mặc định của IconButton
                                constraints: BoxConstraints(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (nowPlayingMovies.isNotEmpty)
                            SizedBox(
                              height: 235, // Chiều cao cố định để chứa các item
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal, // Cuộn ngang
                                itemCount: min(7, nowPlayingMovies.length),
                                itemBuilder: (context, index) {
                                  final movie = nowPlayingMovies[index];
                                  return Container(
                                    width: 145,
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF292B37),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                          ),
                                          child: Image.network(
                                            "https://image.tmdb.org/t/p/w500${movie.backdropPath ?? ''}",
                                            height: 180,
                                            width: 150,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return const Center(
                                                    child: Text(
                                                      'Lỗi tải hình ảnh',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  );
                                                },
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: Text(
                                                  movie.title,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
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
                                              // SizedBox(height: 5),
                                              // Text(
                                              //   'Release: ${movie.releaseDate}',
                                              //   style: const TextStyle(
                                              //     color: Colors.white70,
                                              //     fontSize: 14,
                                              //   ),
                                              // ),
                                              // SizedBox(height: 5),
                                            ],
                                          ),
                                        ), // Thêm padding để tránh lỗi
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
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
        ],
      ),
      bottomNavigationBar: CustomFooter(
        selectedIndex: 0,
        onItemSelected: (index) {},
      ),
    );
  }
}
