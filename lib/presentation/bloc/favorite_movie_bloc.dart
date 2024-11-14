import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nmms_movie_list/domain/entities/movie.dart';
import 'package:nmms_movie_list/domain/usecases/get_favorite_movies.dart';
import 'package:nmms_movie_list/domain/usecases/remove_favorite_movie.dart';

// Events
abstract class FavoriteMovieEvent {}

class GetFavoriteMoviesEvent extends FavoriteMovieEvent {}

class RemoveFavoriteMovieEvent extends FavoriteMovieEvent {
  final int movieId;
  RemoveFavoriteMovieEvent(this.movieId);
}

// States
abstract class FavoriteMovieState {}

class FavoriteMovieInitial extends FavoriteMovieState {}

class FavoriteMovieLoading extends FavoriteMovieState {}

class FavoriteMovieLoaded extends FavoriteMovieState {
  final List<Movie> movies;
  FavoriteMovieLoaded(this.movies);
}

class FavoriteMovieError extends FavoriteMovieState {
  final String message;
  FavoriteMovieError(this.message);
}

// Bloc
class FavoriteMovieBloc extends Bloc<FavoriteMovieEvent, FavoriteMovieState> {
  final GetFavoriteMovies getFavoriteMovies;
  final RemoveFavoriteMovie removeFavoriteMovie;

  FavoriteMovieBloc(this.getFavoriteMovies, this.removeFavoriteMovie)
      : super(FavoriteMovieInitial()) {
    on<GetFavoriteMoviesEvent>((event, emit) async {
      emit(FavoriteMovieLoading());
      final result = await getFavoriteMovies.execute();
      result.fold(
        (failure) => emit(FavoriteMovieError(failure)),
        (movies) => emit(FavoriteMovieLoaded(movies)),
      );
    });

    on<RemoveFavoriteMovieEvent>((event, emit) async {
      final currentState = state;
      if (currentState is FavoriteMovieLoaded) {
        final result = await removeFavoriteMovie.execute(event.movieId);
        result.fold(
          (failure) => emit(FavoriteMovieError(failure)),
          (_) => add(GetFavoriteMoviesEvent()),
        );
      }
    });
  }
}
