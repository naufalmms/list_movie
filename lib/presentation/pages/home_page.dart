import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nmms_movie_list/presentation/bloc/movie_bloc.dart';
import 'package:nmms_movie_list/presentation/widgets/movie_card.dart';
import 'package:nmms_movie_list/presentation/widgets/movie_search_delegate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(_onScroll);

    context.read<MovieBloc>().add(GetNowPlayingMoviesEvent(1));
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _currentPage++;
      if (_tabController.index == 0) {
        context.read<MovieBloc>().add(GetNowPlayingMoviesEvent(_currentPage));
      } else {
        context.read<MovieBloc>().add(GetUpcomingMoviesEvent(_currentPage));
      }
    }

    if (_scrollController.position.pixels ==
        _scrollController.position.minScrollExtent) {
      if (_currentPage > 1) {
        _currentPage--;
        if (_tabController.index == 0) {
          context.read<MovieBloc>().add(GetNowPlayingMoviesEvent(_currentPage));
        } else {
          context.read<MovieBloc>().add(GetUpcomingMoviesEvent(_currentPage));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie App'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Now Playing'),
            Tab(text: 'Upcoming'),
          ],
          onTap: (index) {
            _currentPage = 1;
            if (index == 0) {
              context.read<MovieBloc>().add(GetNowPlayingMoviesEvent(1));
            } else {
              context.read<MovieBloc>().add(GetUpcomingMoviesEvent(1));
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.pushNamed(context, '/favorites');
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MovieSearchDelegate(context.read<MovieBloc>()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieLoading && _currentPage == 1) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieLoaded) {
            return GridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              padding: const EdgeInsets.all(8),
              itemCount: state.movies.length + (state.hasReachedMax ? 0 : 1),
              itemBuilder: (context, index) {
                if (index >= state.movies.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                final movie = state.movies[index];
                return MovieCard(movie: movie);
              },
            );
          } else if (state is MovieError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}
