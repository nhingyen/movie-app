import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movie_app/model/movie_model.dart';
import 'package:movie_app/screens/home_screen/home_screen.dart';
import 'package:movie_app/screens/movie_detail/movie_detail_screen.dart';
import 'package:movie_app/services/firestore_service.dart';

class SearchMovieScreen extends StatefulWidget {
  const SearchMovieScreen({Key? key}) : super(key: key);

  @override
  _SearchMovieScreenState createState() => _SearchMovieScreenState();
}

class _SearchMovieScreenState extends State<SearchMovieScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  String _keyword = '';
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      setState(() {
        _keyword = value.trim();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(31, 43, 42, 42),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          iconSize: 24,
        ),
        title: const Text("Tìm kiếm phim"),
        backgroundColor: const Color.fromARGB(31, 43, 42, 42),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Ô nhập tìm kiếm
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Nhập tên phim...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),

          // Kết quả tìm kiếm
          Expanded(
            child: _keyword.isEmpty
                ? const Center(
                    child: Text(
                      'Nhập từ khóa để tìm phim',
                      style: TextStyle(color: Colors.white54),
                    ),
                  )
                : StreamBuilder<List<MovieModel>>(
                    stream: _firestoreService.searchMovies(_keyword),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            'Không tìm thấy phim nào',
                            style: TextStyle(color: Colors.white54),
                          ),
                        );
                      }
                      final movies = snapshot.data!;
                      return ListView.builder(
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          return ListTile(
                            // contentPadding: const EdgeInsets.symmetric(
                            //   horizontal: 10.0,
                            //   vertical: 1.0,
                            // ),
                            leading:
                                movie.posterPath != null &&
                                    movie.posterPath!.isNotEmpty
                                ? Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        8,
                                      ), // bo ảnh theo container
                                      child: Image.network(
                                        "https://image.tmdb.org/t/p/w500${movie.backdropPath ?? ''}",
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.movie),
                            title: Text(
                              movie.title ?? '',
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(movie.releaseDate ?? ''),
                            onTap: () {
                              print(
                                'Tapped movie: ${movie.title}, ID: ${movie.id}',
                              ); // Log movie.id
                              if (movie.id == null || movie.id!.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Lỗi: ID phim không hợp lệ'),
                                  ),
                                );
                                return;
                              }
                              print(
                                'Navigating to MovieDetailScreen with ID: ${movie.id}',
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MovieDetailScreen(movieId: movie.id),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
