import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_app/model/movie_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _category = "movies";

  //them 1 movie
  Future<void> addMovie(MovieModel movie) async {
    try {
      await _db.collection(_category).doc(movie.id).set(movie.toMap());
    } catch (e) {
      print('Error adding movie: $e');
    }
  }

  //lay danh sach movies
  Future<List<MovieModel>> getMovies() async {
    try {
      final snapshot = await _db.collection(_category).get();
      return snapshot.docs
          .map((doc) => MovieModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching movies: $e");
      return [];
    }
  }

  // Lấy movies theo category
  Future<List<MovieModel>> getMoviesByCategory(String category) async {
    try {
      final snapshot = await _db
          .collection(_category)
          .where('category', isEqualTo: category)
          .orderBy('voteAverage', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => MovieModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching movies by category: $e");
      return [];
    }
  }

  // Lấy movies theo category với Stream (realtime)
  Stream<List<MovieModel>> getMoviesByCategoryStream(String category) {
    return _db
        .collection(_category)
        .where('category', isEqualTo: category)
        .orderBy('voteAverage', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MovieModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // Lấy tất cả movies với Stream (realtime)
  Stream<List<MovieModel>> getMoviesStream() {
    return _db
        .collection(_category)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MovieModel.fromMap(doc.data()))
              .toList(),
        );
  }

  //Xoa movie theo ID
  Future<void> deleteMovie(String id) async {
    try {
      await _db.collection(_category).doc(id).delete();
    } catch (e) {
      print("Erroe deleting movie: $e");
    }
  }

  //cap nhat movie
  Future<void> updateMovie(MovieModel movie) async {
    try {
      await _db.collection(_category).doc(movie.id).update(movie.toMap());
    } catch (e) {
      print('Error updating movie: $e');
    }
  }

  //lay movie theo ID
  Future<MovieModel?> getMovieById(String id) async {
    try {
      final doc = await _db.collection(_category).doc(id).get();
      if (doc.exists) {
        return MovieModel.fromMap(doc.data()!);
      }
    } catch (e) {
      print('Error getting movie by ID: $e');
    }
    return null;
  }
}
