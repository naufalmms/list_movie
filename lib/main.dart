import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nmms_movie_list/presentation/bloc/favorite_movie_bloc.dart';
import 'package:nmms_movie_list/presentation/bloc/movie_bloc.dart';
import 'package:nmms_movie_list/presentation/pages/home_page.dart';
import 'injection.dart' as di;
import 'presentation/pages/favorite_movie_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.getIt<MovieBloc>()..add(GetMoviesEvent()),
        ),
        BlocProvider(
          create: (_) => di.getIt<FavoriteMovieBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Movie App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/favorites': (context) => const FavoriteMoviePage(),
        },
      ),
    );
  }
}
