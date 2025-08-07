// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieModelAdapter extends TypeAdapter<MovieModel> {
  @override
  final int typeId = 0;

  @override
  MovieModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieModel(
      id: fields[0] as String,
      title: fields[1] as String,
      posterPath: fields[2] as String,
      backdropPath: fields[3] as String,
      voteAverage: fields[4] as double,
      releaseDate: fields[5] as String,
      overview: fields[6] as String,
      genreIds: (fields[7] as List?)?.cast<int>(),
      genres: (fields[8] as List?)?.cast<Genre>(),
      runtime: fields[9] as int?,
      video: fields[10] as bool?,
      category: fields[11] as String?,
      timestamp: fields[12] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MovieModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.posterPath)
      ..writeByte(3)
      ..write(obj.backdropPath)
      ..writeByte(4)
      ..write(obj.voteAverage)
      ..writeByte(5)
      ..write(obj.releaseDate)
      ..writeByte(6)
      ..write(obj.overview)
      ..writeByte(7)
      ..write(obj.genreIds)
      ..writeByte(8)
      ..write(obj.genres)
      ..writeByte(9)
      ..write(obj.runtime)
      ..writeByte(10)
      ..write(obj.video)
      ..writeByte(11)
      ..write(obj.category)
      ..writeByte(12)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
