import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nmms_movie_list/presentation/bloc/favorite_movie_bloc.dart';
import 'package:nmms_movie_list/domain/entities/movie.dart';
import 'package:nmms_movie_list/presentation/pages/movie_detail_page.dart';

class FavoriteMoviePage extends StatefulWidget {
  const FavoriteMoviePage({super.key});

  @override
  _FavoriteMoviePageState createState() => _FavoriteMoviePageState();
}

class _FavoriteMoviePageState extends State<FavoriteMoviePage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoriteMovieBloc>().add(GetFavoriteMoviesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Movies'),
      ),
      body: BlocBuilder<FavoriteMovieBloc, FavoriteMovieState>(
        builder: (context, state) {
          if (state is FavoriteMovieLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoriteMovieLoaded) {
            if (state.movies.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No favorite movies yet',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: state.movies.length,
              itemBuilder: (context, index) {
                final Movie movie = state.movies[index];
                return Dismissible(
                  key: Key(movie.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    // Implement remove from favorites
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${movie.title} removed from favorites'),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            // Implement undo functionality
                          },
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        context
                            .read<FavoriteMovieBloc>()
                            .add(RemoveFavoriteMovieEvent(movie.id));
                      },
                    ),
                    leading: movie.posterPath.isNotEmpty
                        ? Image.network(
                            'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                            width: 56,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 56,
                              height: 84,
                              color: Colors.grey[300],
                              child: const Icon(Icons.movie),
                            ),
                          )
                        : Container(
                            width: 56,
                            height: 84,
                            color: Colors.grey[300],
                            child: const Icon(Icons.movie),
                          ),
                    title: Text(
                      movie.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      movie.overview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailPage(movie: movie),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is FavoriteMovieError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<FavoriteMovieBloc>()
                          .add(GetFavoriteMoviesEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
