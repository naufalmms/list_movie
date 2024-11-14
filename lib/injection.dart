import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nmms_movie_list/core/network/network_info.dart';
import 'package:nmms_movie_list/core/utils/constants.dart';
import 'package:nmms_movie_list/data/datasources/local/movie_local_datasource.dart';
import 'package:nmms_movie_list/data/datasources/remote/movie_remote_datasource.dart';
import 'package:nmms_movie_list/data/repositories/movie_repository_impl.dart';
import 'package:nmms_movie_list/domain/repositories/movie_repository.dart';
import 'package:nmms_movie_list/domain/usecases/add_favorite_movie.dart';
import 'package:nmms_movie_list/domain/usecases/get_favorite_movies.dart';
import 'package:nmms_movie_list/domain/usecases/get_movies.dart';
import 'package:nmms_movie_list/domain/usecases/get_now_playing_movies.dart';
import 'package:nmms_movie_list/domain/usecases/get_upcoming_movies.dart';
import 'package:nmms_movie_list/domain/usecases/remove_favorite_movie.dart';
import 'package:nmms_movie_list/domain/usecases/search_movies.dart';
import 'package:nmms_movie_list/presentation/bloc/favorite_movie_bloc.dart';
import 'package:nmms_movie_list/presentation/bloc/movie_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // External
  final database = await openDatabase(
    join(await getDatabasesPath(), Constants.DATABASE_NAME),
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE ${Constants.FAVORITE_MOVIES_TABLE} (
          id INTEGER PRIMARY KEY,
          title TEXT,
          overview TEXT,
          poster_path TEXT,
          is_favorite INTEGER
        )
      ''');
    },
    version: Constants.DATABASE_VERSION,
  );
  getIt.registerLazySingleton(() => database);

  // Network
  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton(
    () => InternetConnectionChecker(),
  );
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt()),
  );

  // Data sources
  getIt.registerLazySingleton(
    () => MovieLocalDataSource(getIt()),
  );
  getIt.registerLazySingleton(
    () => MovieRemoteDataSource(),
  );

  // Repository
  getIt.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      getIt(),
      getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetMovies(getIt()));
  getIt.registerLazySingleton(() => GetNowPlayingMovies(getIt()));
  getIt.registerLazySingleton(() => GetUpcomingMovies(getIt()));
  getIt.registerLazySingleton(() => GetFavoriteMovies(getIt()));
  getIt.registerLazySingleton(() => AddFavoriteMovie(getIt()));
  getIt.registerLazySingleton(() => RemoveFavoriteMovie(getIt()));
  getIt.registerLazySingleton(() => SearchMovies(getIt()));

  // BLoCs
  getIt.registerFactory(
    () => MovieBloc(getIt(), getIt(), getIt(), getIt(), getIt()),
  );
  getIt.registerFactory(
    () => FavoriteMovieBloc(getIt(), getIt()),
  );
}
