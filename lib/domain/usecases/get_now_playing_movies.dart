import 'package:dartz/dartz.dart';
import 'package:nmms_movie_list/domain/repositories/movie_repository.dart';
import 'package:nmms_movie_list/domain/entities/movie.dart';

class GetNowPlayingMovies {
  final MovieRepository repository;

  GetNowPlayingMovies(this.repository);

  Future<Either<String, List<Movie>>> execute(int page) async {
    return await repository.getNowPlayingMovies(page);
  }
}
