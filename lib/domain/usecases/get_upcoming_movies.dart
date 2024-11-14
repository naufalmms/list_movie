import 'package:dartz/dartz.dart';
import 'package:nmms_movie_list/domain/repositories/movie_repository.dart';
import 'package:nmms_movie_list/domain/entities/movie.dart';

class GetUpcomingMovies {
  final MovieRepository repository;

  GetUpcomingMovies(this.repository);

  Future<Either<String, List<Movie>>> execute(int page) async {
    return await repository.getUpcomingMovies(page);
  }
}
