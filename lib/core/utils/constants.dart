class Constants {
  static const String API_BASE_URL = 'https://api.themoviedb.org/3';
  static const String API_KEY = 'b4d8656837fadea00b513f90707d1e61';
  static const String IMAGE_BASE_URL = 'https://image.tmdb.org/t/p';

  // API Endpoints
  static const String POPULAR_MOVIES = '/movie/popular';
  static const String SEARCH_MOVIES = '/search/movie';
  static const String NOW_PLAYING = '/movie/now_playing';
  static const String UPCOMING = '/movie/upcoming';

  // Database
  static const String DATABASE_NAME = 'movie_app.db';
  static const int DATABASE_VERSION = 1;

  // Tables
  static const String FAVORITE_MOVIES_TABLE = 'favorite_movies';
}
