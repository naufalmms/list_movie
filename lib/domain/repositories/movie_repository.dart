import 'package:dartz/dartz.dart';
import 'package:nmms_movie_list/domain/entities/movie.dart';

abstract class MovieRepository {
  Future<Either<String, List<Movie>>> getMovies();
  Future<Either<String, List<Movie>>> getNowPlayingMovies(int page);
  Future<Either<String, List<Movie>>> getUpcomingMovies(int page);
  Future<Either<String, List<Movie>>> getFavoriteMovies();
  Future<Either<String, void>> addFavoriteMovie(Movie movie);
  Future<Either<String, void>> removeFavoriteMovie(int movieId);
  Future<Either<String, List<Movie>>> searchMovies(String query);
}
