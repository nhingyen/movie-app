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
  final String? status; // Trạng thái
  final double? popularity; // Độ phổ biến
  final int? voteCount;
  final int? runtime;
  final bool? video; // Có phải video không

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
    this.status,
    this.popularity,
    this.voteCount,
    this.runtime,
    this.video,
  });

  factory MovieModel.fromMap(Map<String, dynamic> map) {
    return MovieModel(
      title: map['title'] ?? '',
      posterPath: map['poster_path'] ?? '',
      id: map['id'].toString(),
      backdropPath: map['backdrop_path'] ?? '',
      voteAverage: (map['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: map['release_date'] ?? '',
      overview: map['overview'],
      runtime: map['runtime'],
      status: map['status'],
      voteCount: map['vote_count]'],
      video: map['video'],
      genreIds: (map['genre_ids'] as List<dynamic>?)
          ?.cast<int>(), // Lấy genre_ids
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
      'status': status,
      'popularity': popularity,
      'vote_count': voteCount,
      'video': video,
    };
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
