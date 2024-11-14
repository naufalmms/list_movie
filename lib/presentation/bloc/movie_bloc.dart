import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nmms_movie_list/domain/entities/movie.dart';
import 'package:nmms_movie_list/domain/usecases/add_favorite_movie.dart';
import 'package:nmms_movie_list/domain/usecases/get_movies.dart';
import 'package:nmms_movie_list/domain/usecases/get_now_playing_movies.dart';
import 'package:nmms_movie_list/domain/usecases/get_upcoming_movies.dart';
import 'package:nmms_movie_list/domain/usecases/search_movies.dart';

// Events
abstract class MovieEvent {}

class GetMoviesEvent extends MovieEvent {}

class AddFavoriteMovieEvent extends MovieEvent {
  final Movie movie;
  AddFavoriteMovieEvent(this.movie);
}

class SearchMoviesEvent extends MovieEvent {
  final String query;
  SearchMoviesEvent(this.query);
}

class GetNowPlayingMoviesEvent extends MovieEvent {
  final int page;
  GetNowPlayingMoviesEvent(this.page);
}

class GetUpcomingMoviesEvent extends MovieEvent {
  final int page;
  GetUpcomingMoviesEvent(this.page);
}

// States
abstract class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

// class MovieLoaded extends MovieState {
//   final List<Movie> movies;
//   MovieLoaded(this.movies);
// }

class MovieLoaded extends MovieState {
  final List<Movie> movies;
  final bool hasReachedMax;
  MovieLoaded(this.movies, this.hasReachedMax);
}

class MovieError extends MovieState {
  final String message;
  MovieError(this.message);
}

// Bloc
class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetMovies getMovies;
  final AddFavoriteMovie addFavoriteMovie;
  final SearchMovies searchMovies;
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetUpcomingMovies getUpcomingMovies;

  MovieBloc(
    this.getMovies,
    this.addFavoriteMovie,
    this.searchMovies,
    this.getNowPlayingMovies,
    this.getUpcomingMovies,
  ) : super(MovieInitial()) {
    on<GetMoviesEvent>((event, emit) async {
      emit(MovieLoading());
      final result = await getMovies.execute();
      result.fold(
        (failure) => emit(MovieError(failure)),
        (movies) => emit(MovieLoaded(movies, true)),
      );
    });

    on<GetNowPlayingMoviesEvent>((event, emit) async {
      emit(MovieLoading());
      final result = await getNowPlayingMovies.execute(event.page);
      result.fold(
        (failure) => emit(MovieError(failure)),
        (movies) => emit(MovieLoaded(movies, movies.length < 20)),
      );
    });

    on<GetUpcomingMoviesEvent>((event, emit) async {
      emit(MovieLoading());
      final result = await getUpcomingMovies.execute(event.page);
      result.fold(
        (failure) => emit(MovieError(failure)),
        (movies) => emit(MovieLoaded(movies, movies.length < 20)),
      );
    });

    on<AddFavoriteMovieEvent>((event, emit) async {
      final result = await addFavoriteMovie.execute(event.movie);
      result.fold(
        (failure) => emit(MovieError(failure)),
        (_) => null,
      );
    });

    on<SearchMoviesEvent>((event, emit) async {
      emit(MovieLoading());
      final result = await searchMovies.execute(event.query);
      result.fold(
        (failure) => emit(MovieError(failure)),
        (movies) => emit(MovieLoaded(movies, true)),
      );
    });
  }
}
