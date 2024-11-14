import 'package:dartz/dartz.dart';
import 'package:nmms_movie_list/domain/repositories/movie_repository.dart';
import '../entities/movie.dart';

class GetMovies {
  final MovieRepository repository;

  GetMovies(this.repository);

  Future<Either<String, List<Movie>>> execute() async {
    return await repository.getMovies();
  }
}
