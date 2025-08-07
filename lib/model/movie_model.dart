import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'movie_model.g.dart';

@HiveType(typeId: 0)
class MovieModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String posterPath;

  @HiveField(3)
  final String backdropPath;

  @HiveField(4)
  final double voteAverage;

  @HiveField(5)
  final String releaseDate;

  @HiveField(6)
  final String overview;

  @HiveField(7)
  final List<int>? genreIds;

  @HiveField(8)
  final List<Genre>? genres;

  @HiveField(9)
  final int? runtime;

  @HiveField(10)
  final bool? video;

  @HiveField(11)
  final String? category;

  @HiveField(12)
  final DateTime? timestamp;

  MovieModel({
    required this.id,
    required this.title,
    required this.posterPath,
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
      id: map['id'].toString(),
      title: map['title'] ?? '',
      posterPath: map['posterPath'] ?? map['poster'] ?? '',
      backdropPath: map['backdropPath'] ?? map['backdrop'] ?? '',
      voteAverage: (map['voteAverage'] as num?)?.toDouble() ?? 0.0,
      releaseDate: map['releaseDate'] ?? '',
      overview: map['overview'] ?? '',
      runtime: map['runtime'] as int?,
      video: map['video'] as bool?,
      category: map['category'] as String?,
      timestamp: (map['timestamp'] as Timestamp?)?.toDate(),
      genreIds:
          (map['genreIds'] as List<dynamic>?)?.cast<int>() ??
          (map['genre_ids'] as List<dynamic>?)?.cast<int>(),
      genres: (map['genres'] as List<dynamic>?)
          ?.map((genre) => Genre.fromMap(genre))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'poster': posterPath,
      'backdrop': backdropPath,
      'voteAverage': voteAverage,
      'releaseDate': releaseDate,
      'overview': overview,
      'genre_ids': genreIds,
      'genres': genres?.map((genre) => genre.toMap()).toList(),
      'runtime': runtime,
      'video': video,
      'category': category,
      'timestamp': FieldValue.serverTimestamp(), // Sử dụng cho Firestore
    };
  }

  // Constructor để sao chép và thêm timestamp
  MovieModel.copyWithTimestamp(MovieModel original, {DateTime? timestamp})
    : this(
        id: original.id,
        title: original.title,
        posterPath: original.posterPath,
        backdropPath: original.backdropPath,
        voteAverage: original.voteAverage,
        releaseDate: original.releaseDate,
        overview: original.overview,
        genreIds: original.genreIds,
        genres: original.genres,
        runtime: original.runtime,
        video: original.video,
        category: original.category,
        timestamp: timestamp ?? DateTime.now(),
      );
  // Phương thức copyWith để cập nhật các trường
  MovieModel copyWith({
    String? id,
    String? title,
    String? posterPath,
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
      id: id ?? this.id,
      title: title ?? this.title,
      posterPath: posterPath ?? this.posterPath,
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
    return 'MovieModel(id: $id, title: $title, category: $category, timestamp: $timestamp)';
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
