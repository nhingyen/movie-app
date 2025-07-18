import 'package:flutter/material.dart';
import 'package:movie_app/model/movie_model.dart';

class TopRatedScreen extends StatefulWidget {
  final List<MovieModel> movies;
  final String title;

  const TopRatedScreen({super.key, required this.movies, required this.title});

  @override
  State<TopRatedScreen> createState() => _TopRatedScreenState();
}

class _TopRatedScreenState extends State<TopRatedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(31, 43, 42, 42),
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color.fromARGB(31, 43, 42, 42),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        itemCount: (widget.movies.length / 3)
            .ceil(), // Số hàng dựa trên 3 item/hàng
        itemBuilder: (context, index) {
          final startIndex = index * 3;
          final endIndex = (startIndex + 3).clamp(0, widget.movies.length);
          final rowMovies = widget.movies.sublist(startIndex, endIndex);

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: rowMovies.map((movie) {
              return Column(
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
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
