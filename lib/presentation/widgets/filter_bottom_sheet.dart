import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nmms_movie_list/domain/entities/genre.dart';
import 'package:nmms_movie_list/presentation/bloc/filter_bloc.dart';

class FilterBottomSheet extends StatelessWidget {
  final List<Genre> genres;

  const FilterBottomSheet({super.key, required this.genres});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterBloc, FilterState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Filter Movies',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'Sort By',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: SortOrder.values.map((sort) {
                  return ChoiceChip(
                    label: Text(_getSortLabel(sort)),
                    selected: state.sortOrder == sort,
                    onSelected: (selected) {
                      if (selected) {
                        context
                            .read<FilterBloc>()
                            .add(UpdateSortOrderEvent(sort));
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text(
                'Genres',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: genres.map((genre) {
                  return FilterChip(
                    label: Text(genre.name),
                    selected: state.selectedGenres.contains(genre.id),
                    onSelected: (selected) {
                      context
                          .read<FilterBloc>()
                          .add(UpdateGenreFilterEvent(genre.id));
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getSortLabel(SortOrder sort) {
    switch (sort) {
      case SortOrder.popularity:
        return 'Popularity';
      case SortOrder.rating:
        return 'Rating';
      case SortOrder.releaseDate:
        return 'Release Date';
    }
  }
}
