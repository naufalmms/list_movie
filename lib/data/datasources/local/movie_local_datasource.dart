import 'package:sqflite/sqflite.dart';
import 'package:nmms_movie_list/data/models/movie_model.dart';

class MovieLocalDataSource {
  final Database database;

  MovieLocalDataSource(this.database);

  Future<void> addFavoriteMovie(MovieModel movie) async {
    await database.insert(
      'favorite_movies',
      movie.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MovieModel>> getFavoriteMovies() async {
    final List<Map<String, dynamic>> maps =
        await database.query('favorite_movies');
    return List.generate(maps.length, (i) => MovieModel.fromJson(maps[i]));
  }

  Future<void> removeFavoriteMovie(int movieId) async {
    await database.delete(
      'favorite_movies',
      where: 'id = ?',
      whereArgs: [movieId],
    );
  }
}
