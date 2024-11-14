import 'package:dartz/dartz.dart';
import 'package:nmms_movie_list/data/models/movie_model.dart';
import 'package:nmms_movie_list/domain/entities/movie.dart';
import 'package:nmms_movie_list/domain/repositories/movie_repository.dart';
import 'package:nmms_movie_list/data/datasources/local/movie_local_datasource.dart';
import 'package:nmms_movie_list/data/datasources/remote/movie_remote_datasource.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;

  MovieRepositoryImpl(
    this.remoteDataSource,
    this.localDataSource,
  );

  @override
  Future<Either<String, List<Movie>>> getMovies() async {
    try {
      final movies = await remoteDataSource.getMovies();
      return Right(movies);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<Movie>>> getNowPlayingMovies(int page) async {
    try {
      final movies = await remoteDataSource.getNowPlayingMovies(page);
      return Right(movies);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<Movie>>> getUpcomingMovies(int page) async {
    try {
      final movies = await remoteDataSource.getUpcomingMovies(page);
      return Right(movies);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> addFavoriteMovie(Movie movie) async {
    try {
      await localDataSource.addFavoriteMovie(MovieModel(
        id: movie.id,
        title: movie.title,
        overview: movie.overview,
        posterPath: movie.posterPath,
        isFavorite: true,
      ));
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<Movie>>> getFavoriteMovies() async {
    try {
      final movies = await localDataSource.getFavoriteMovies();
      return Right(movies);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> removeFavoriteMovie(int movieId) async {
    try {
      await localDataSource.removeFavoriteMovie(movieId);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<Movie>>> searchMovies(String query) async {
    try {
      final movies = await remoteDataSource.searchMovies(query);
      return Right(movies);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
