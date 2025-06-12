import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'home_screen.dart'; // Movie and Series classes are here

class WatchlistManager {
  static final WatchlistManager _instance = WatchlistManager._internal();
  factory WatchlistManager() => _instance;
  WatchlistManager._internal();

  final List<Movie> _movieWatchlist = [];
  final List<Series> _seriesWatchlist = [];

  List<Movie> get movieWatchlist => _movieWatchlist;
  List<Series> get seriesWatchlist => _seriesWatchlist;

  Future<void> loadWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    // Load movies
    final movieData = prefs.getString('movie_watchlist');
    if (movieData != null) {
      List decoded = jsonDecode(movieData);
      _movieWatchlist.clear();
      _movieWatchlist.addAll(decoded.map((e) => Movie(
            title: e['title'],
            imageUrl: e['imageUrl'],
            genre: e['genre'],
            description: e['description'],
            videoUrl: e['videoUrl'],
          )));
    }
    // Load series
   final seriesData = prefs.getString('series_watchlist');
if (seriesData != null) {
  List decoded = jsonDecode(seriesData);
  _seriesWatchlist.clear();
  _seriesWatchlist.addAll(decoded.map((e) => Series.fromJson(e)));
}

  }

  Future<void> saveMovieWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, String>> movieList = _movieWatchlist.map((movie) {
      return {
        'title': movie.title,
        'imageUrl': movie.imageUrl,
        'genre': movie.genre,
        'description': movie.description,
        'videoUrl': movie.videoUrl,
      };
    }).toList();
    prefs.setString('movie_watchlist', jsonEncode(movieList));
  }

  Future<void> saveSeriesWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> seriesList = _seriesWatchlist.map((series) {
      return {
        'title': series.title,
        'imageUrl': series.imageUrl,
        'genre': series.genre,
        'description': series.description,
        'videoUrl': series.videoUrl,
        'seasons': series.seasons,
        'episodes': series.episodes,
      };
    }).toList();
    prefs.setString('series_watchlist', jsonEncode(seriesList));
  }

  // Movie methods
  void addMovie(Movie movie) {
    if (!_movieWatchlist.any((m) => m.title == movie.title)) {
      _movieWatchlist.add(movie);
      saveMovieWatchlist();
    }
  }

  void removeMovie(Movie movie) {
    _movieWatchlist.removeWhere((m) => m.title == movie.title);
    saveMovieWatchlist();
  }

  bool isInWatchlist(Movie movie) {
    return _movieWatchlist.any((m) => m.title == movie.title);
  }

  // Series methods
  void addSeries(Series series) {
    if (!_seriesWatchlist.any((s) => s.title == series.title)) {
      _seriesWatchlist.add(series);
      saveSeriesWatchlist();
    }
  }

  void removeSeries(Series series) {
    _seriesWatchlist.removeWhere((s) => s.title == series.title);
    saveSeriesWatchlist();
  }

  bool isSeriesInWatchlist(Series series) {
    return _seriesWatchlist.any((s) => s.title == series.title);
  }
}
