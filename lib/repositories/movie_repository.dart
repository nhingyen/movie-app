// lib/repository/movie_repository.dart
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/model/movie_model.dart';

class MovieRepository {
  final FirebaseFirestore firestore;

  MovieRepository({required this.firestore});

  /// Lấy chi tiết phim từ Firestore
  Future<MovieModel?> getMovieFromFirestore(String movieId) async {
    final doc = await firestore.collection("movies").doc(movieId).get();
    if (!doc.exists) return null;
    print("Fetching movie with id: ${doc.id}, data: ${doc.data()}");
    return MovieModel.fromMap(doc.data()!);
  }

  /// Lấy danh sách phim theo category
  Future<List<MovieModel>> getMoviesByCategory(String category) async {
    final snapshot = await firestore
        .collection("movies")
        .where("category", isEqualTo: category)
        .get();

    return snapshot.docs.map((doc) => MovieModel.fromMap(doc.data())).toList();
  }

  /// Lấy trailer từ TMDB
  Future<String?> getTrailerKey(String tmdbId) async {
    final url = Uri.parse(
      "https://api.themoviedb.org/3/movie/$tmdbId/videos?api_key=YOUR_API_KEY",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final videos = data['results'] as List<dynamic>;
      if (videos.isNotEmpty) {
        final trailer = videos.firstWhere(
          (v) => v['type'] == 'Trailer' && v['site'] == 'YouTube',
          orElse: () => null,
        );
        return trailer != null ? trailer['key'] : null;
      }
    }
    return null;
  }
}
