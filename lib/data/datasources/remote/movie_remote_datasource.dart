import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nmms_movie_list/core/utils/constants.dart';
import 'package:nmms_movie_list/data/models/movie_model.dart';

class MovieRemoteDataSource {
  MovieRemoteDataSource();

  Future<List<MovieModel>> getMovies() async {
    final response = await http.get(
      Uri.parse(
          '${Constants.API_BASE_URL}${Constants.POPULAR_MOVIES}?api_key=${Constants.API_KEY}'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> movies = json.decode(response.body)['results'];
      return movies.map((movie) => MovieModel.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<MovieModel>> getNowPlayingMovies(int page) async {
    final uri = Uri.parse('${Constants.API_BASE_URL}${Constants.NOW_PLAYING}')
        .replace(queryParameters: {
      'api_key': Constants.API_KEY,
      'page': page.toString(),
    });
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> movies = json.decode(response.body)['results'];
      return movies.map((movie) => MovieModel.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<MovieModel>> getUpcomingMovies(int page) async {
    final uri = Uri.parse('${Constants.API_BASE_URL}${Constants.UPCOMING}')
        .replace(queryParameters: {
      'api_key': Constants.API_KEY,
      'page': page.toString(),
    });
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> movies = json.decode(response.body)['results'];
      return movies.map((movie) => MovieModel.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse(
        '${Constants.API_BASE_URL}${Constants.SEARCH_MOVIES}?api_key=${Constants.API_KEY}&query=$query',
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> movies = json.decode(response.body)['results'];
      return movies.map((movie) => MovieModel.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to search movies');
    }
  }
}
