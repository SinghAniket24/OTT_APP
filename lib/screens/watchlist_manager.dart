import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'home_screen.dart'; // import your existing Movie class

class WatchlistManager {
  static final WatchlistManager _instance = WatchlistManager._internal();
  factory WatchlistManager() => _instance;
  WatchlistManager._internal();

  final List<Movie> _watchlist = [];

  List<Movie> get watchlist => _watchlist;

  Future<void> loadWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('watchlist');
    if (data != null) {
      List decoded = jsonDecode(data);
      _watchlist.clear();
      _watchlist.addAll(decoded.map((e) => Movie(
            title: e['title'],
            imageUrl: e['imageUrl'],
            genre: e['genre'],
            description: e['description'],
            videoUrl: e['videoUrl'],
          )));
    }
  }

  Future<void> saveWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, String>> movieList = _watchlist.map((movie) {
      return {
        'title': movie.title,
        'imageUrl': movie.imageUrl,
        'genre': movie.genre,
        'description': movie.description,
        'videoUrl': movie.videoUrl,
      };
    }).toList();

    prefs.setString('watchlist', jsonEncode(movieList));
  }

  void addMovie(Movie movie) {
    if (!_watchlist.any((m) => m.title == movie.title)) {
      _watchlist.add(movie);
      saveWatchlist();
    }
  }

  void removeMovie(Movie movie) {
    _watchlist.removeWhere((m) => m.title == movie.title);
    saveWatchlist();
  }

  bool isInWatchlist(Movie movie) {
    return _watchlist.any((m) => m.title == movie.title);
  }
}
