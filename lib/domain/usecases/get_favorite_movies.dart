import 'package:dartz/dartz.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetFavoriteMovies {
  final MovieRepository repository;

  GetFavoriteMovies(this.repository);

  Future<Either<String, List<Movie>>> execute() async {
    return await repository.getFavoriteMovies();
  }
}
