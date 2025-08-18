import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_app/model/movie_model.dart';
import 'package:movie_app/screens/home_screen/home_screen.dart';
import 'package:movie_app/screens/movie_detail/movie_detail_screen.dart';
import 'package:movie_app/services/hive_setup.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Box<MovieModel> favoriteBox;
  @override
  void initState() {
    super.initState();
    favoriteBox = HiveSetup.getFavoritesBox();
  }

  void removeFavorite(String id) {
    setState(() {
      favoriteBox.delete(id);
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
        title: const Text("Phim Yêu Thích"),
        backgroundColor: const Color.fromARGB(31, 43, 42, 42),
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder(
        valueListenable: favoriteBox.listenable(),
        builder: (context, box, child) {
          final favorites = favoriteBox.values.toList();
          favorites.sort(
            (a, b) => (b.timestamp ?? DateTime(0)).compareTo(
              a.timestamp ?? DateTime(0),
            ),
          );
          if (favorites.isEmpty) {
            return const Center(
              child: Text(
                'Không có phim yêu thích',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(10),
                //   child: Text(
                //     'Phim Yêu Thích',
                //     style: GoogleFonts.robotoSlab(
                //       textStyle: const TextStyle(
                //         fontSize: 20,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
                GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 10,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 3,
                    childAspectRatio: 0.463, //ti le rong/cao
                  ),
                  itemCount: favorites.length,
                  shrinkWrap: true, // Giới hạn kích thước của GridView
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final movie = favorites[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailScreen(
                              movieId: movie.id.toString(),
                              initialMovie: movie,
                            ),
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
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
