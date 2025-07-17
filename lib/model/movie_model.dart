class MovieModel {
  final String title;
  final String posterPath;
  final String id;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;
  MovieModel({
    required this.title,
    required this.posterPath,
    required this.id,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
  });

  factory MovieModel.fromMap(Map<String, dynamic> map) {
    return MovieModel(
      title: map['title'] ?? '',
      posterPath: map['poster_path'] ?? '',
      id: map['id'].toString(),
      backdropPath: map['backdrop_path'] ?? '',
      voteAverage: (map['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: map['release_date'] ?? '',
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
    };
  }
}
