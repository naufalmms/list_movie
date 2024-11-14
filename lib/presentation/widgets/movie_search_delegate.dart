import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nmms_movie_list/presentation/bloc/movie_bloc.dart';
import 'package:nmms_movie_list/presentation/widgets/movie_card.dart';

class MovieSearchDelegate extends SearchDelegate {
  final MovieBloc movieBloc;

  MovieSearchDelegate(this.movieBloc);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isEmpty) return Container();

    movieBloc.add(SearchMoviesEvent(query));

    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, state) {
        if (state is MovieLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MovieLoaded) {
          if (state.movies.isEmpty) {
            return const Center(child: Text('No results found'));
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            padding: const EdgeInsets.all(8),
            itemCount: state.movies.length,
            itemBuilder: (context, index) {
              return MovieCard(movie: state.movies[index]);
            },
          );
        } else if (state is MovieError) {
          return const Center(child: Text('Error searching movies'));
        }
        return Container();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
