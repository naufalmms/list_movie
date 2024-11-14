import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class FilterEvent {}

class UpdateGenreFilterEvent extends FilterEvent {
  final int genreId;
  UpdateGenreFilterEvent(this.genreId);
}

class UpdateSortOrderEvent extends FilterEvent {
  final SortOrder sortOrder;
  UpdateSortOrderEvent(this.sortOrder);
}

// States
enum SortOrder { popularity, rating, releaseDate }

class FilterState {
  final List<int> selectedGenres;
  final SortOrder sortOrder;

  FilterState({
    this.selectedGenres = const [],
    this.sortOrder = SortOrder.popularity,
  });

  FilterState copyWith({
    List<int>? selectedGenres,
    SortOrder? sortOrder,
  }) {
    return FilterState(
      selectedGenres: selectedGenres ?? this.selectedGenres,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

//BLOC
class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(FilterState()) {
    on<UpdateGenreFilterEvent>((event, emit) {
      final currentGenres = List<int>.from(state.selectedGenres);
      if (currentGenres.contains(event.genreId)) {
        currentGenres.remove(event.genreId);
      } else {
        currentGenres.add(event.genreId);
      }
      emit(state.copyWith(selectedGenres: currentGenres));
    });

    on<UpdateSortOrderEvent>((event, emit) {
      emit(state.copyWith(sortOrder: event.sortOrder));
    });
  }
}
