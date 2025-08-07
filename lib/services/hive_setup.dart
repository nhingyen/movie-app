import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_app/model/movie_model.dart';

class HiveSetup {
  static const String _favoriteBox = 'favoriteBox';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(MovieModelAdapter());
    await Hive.openBox<MovieModel>(_favoriteBox);
  }

  static Box<MovieModel> getFavoritesBox() =>
      Hive.box<MovieModel>(_favoriteBox);
}
