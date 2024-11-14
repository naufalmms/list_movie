import 'package:dartz/dartz.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class SearchMovies {
  final MovieRepository repository;

  SearchMovies(this.repository);

  Future<Either<String, List<Movie>>> execute(String query) async {
    return await repository.searchMovies(query);
  }
}
