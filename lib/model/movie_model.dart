import 'package:cloud_firestore/cloud_firestore.dart';

class MovieModel {
  final String title;
  final String posterPath;
  final String id;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;
  final String overview;
  final List<int>? genreIds;
  final List<Genre>? genres;
  final int? runtime;
  final bool? video;
  final String? category;
  final DateTime? timestamp;

  MovieModel({
    required this.title,
    required this.posterPath,
    required this.id,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.overview,
    this.genreIds,
    this.genres,
    this.runtime,
    this.video,
    this.category,
    this.timestamp,
  });

  factory MovieModel.fromMap(Map<String, dynamic> map) {
    return MovieModel(
      title: map['title'] ?? '',
      posterPath:
          map['posterPath'] ?? map['poster'] ?? '', // Hỗ trợ cả 2 tên field
      id: map['id'].toString(),
      backdropPath: map['backdropPath'] ?? map['backdrop'] ?? '',
      voteAverage: (map['voteAverage'] as num?)?.toDouble() ?? 0.0,
      releaseDate: map['releaseDate'] ?? '',
      overview: map['overview'],
      runtime: map['runtime'],
      video: map['video'],
      category: map['category'],
      timestamp: (map['timestamp'] as Timestamp?)?.toDate(),
      genreIds:
          (map['genreIds'] as List<dynamic>?)?.cast<int>() ??
          (map['genre_ids'] as List<dynamic>?)?.cast<int>(), // Lấy genre_ids
      genres: (map['genres'] as List<dynamic>?)
          ?.map((genre) => Genre.fromMap(genre))
          .toList(), // Lấy genres nếu có (từ /movie/{movie_id})
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'poster': posterPath,
      'id': id,
      'backdrop': backdropPath,
      'voteAverage': voteAverage,
      'releaseDate': releaseDate,
      'overview': overview,
      'genre_ids': genreIds,
      'genres': genres?.map((genre) => genre.toMap()).toList(),
      'runtime': runtime,
      'video': video,
      'category': category,
      'timestamp': FieldValue.serverTimestamp(), // Firestore timestamp
    };
  }

  // Thêm copyWith method để dễ dàng tạo bản sao
  MovieModel copyWith({
    String? title,
    String? posterPath,
    String? id,
    String? backdropPath,
    double? voteAverage,
    String? releaseDate,
    String? overview,
    List<int>? genreIds,
    List<Genre>? genres,
    int? runtime,
    bool? video,
    String? category,
    DateTime? timestamp,
  }) {
    return MovieModel(
      title: title ?? this.title,
      posterPath: posterPath ?? this.posterPath,
      id: id ?? this.id,
      backdropPath: backdropPath ?? this.backdropPath,
      voteAverage: voteAverage ?? this.voteAverage,
      releaseDate: releaseDate ?? this.releaseDate,
      overview: overview ?? this.overview,
      genreIds: genreIds ?? this.genreIds,
      genres: genres ?? this.genres,
      runtime: runtime ?? this.runtime,
      video: video ?? this.video,
      category: category ?? this.category,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'MovieModel(id: $id, title: $title, category: $category)';
  }
}

class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromMap(Map<String, dynamic> map) {
    return Genre(id: map['id'] ?? 0, name: map['name'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}
