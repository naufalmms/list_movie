import 'package:dartz/dartz.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class AddFavoriteMovie {
  final MovieRepository repository;

  AddFavoriteMovie(this.repository);

  Future<Either<String, void>> execute(Movie movie) async {
    return await repository.addFavoriteMovie(movie);
  }
}
