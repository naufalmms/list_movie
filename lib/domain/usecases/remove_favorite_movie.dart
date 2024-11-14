import 'package:dartz/dartz.dart';
import 'package:nmms_movie_list/domain/repositories/movie_repository.dart';

class RemoveFavoriteMovie {
  final MovieRepository repository;

  RemoveFavoriteMovie(this.repository);

  Future<Either<String, void>> execute(int movieId) async {
    return await repository.removeFavoriteMovie(movieId);
  }
}
