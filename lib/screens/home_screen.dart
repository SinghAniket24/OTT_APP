import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'movie_detail_page.dart';
import 'series_detail_page.dart';
import 'searchresuts.dart';
import 'genre_movie_screen.dart';

// Movie class
class Movie {
  final String title;
  final String imageUrl;
  final String genre;
  final String description;
  final String videoUrl;
  final String? movieUrl;
  final String? director;
  final double? rating;
  final List<MovieCast>? cast;

  Movie({
    required this.title,
    required this.imageUrl,
    required this.genre,
    required this.description,
    required this.videoUrl,
    this.movieUrl,
    this.director,
    this.rating,
    this.cast,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      imageUrl: json['imageUrl'],
      genre: json['genre'],
      description: json['description'],
      videoUrl: json['videoUrl'],
      movieUrl: json['movieUrl'],
      director: json['director'],
      rating: (json['rating'] != null)
          ? double.tryParse(json['rating'].toString())
          : null,
      cast: (json['cast'] != null)
          ? (json['cast'] as List)
              .map((c) => MovieCast.fromJson(c))
              .toList()
          : null,
    );
  }
}

class MovieCast {
  final String name;
  final String role;
  final String image;

  MovieCast({
    required this.name,
    required this.role,
    required this.image,
  });

  factory MovieCast.fromJson(Map<String, dynamic> json) {
    return MovieCast(
      name: json['name'],
      role: json['role'],
      image: json['image'],
    );
  }
}

// Series class (separate from Movie)
class Series {
  final String title;
  final String imageUrl;
  final String genre;
  final String description;
  final String videoUrl;
  final int seasons;
  final int episodes;
  final String? director;
  final double? rating;
  final List<Cast>? cast;
  final List<SeasonDetail> seasonDetails;

  Series({
    required this.title,
    required this.imageUrl,
    required this.genre,
    required this.description,
    required this.videoUrl,
    required this.seasons,
    required this.episodes,
    this.director,
    this.rating,
    this.cast,
    required this.seasonDetails,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      title: json['title'],
      imageUrl: json['imageUrl'],
      genre: json['genre'],
      description: json['description'],
      videoUrl: json['videoUrl'],
      seasons: json['seasons'],
      episodes: json['episodes'],
      director: json['director'],
      rating: (json['rating'] != null) ? json['rating'].toDouble() : null,
      cast: (json['cast'] != null)
          ? (json['cast'] as List).map((c) => Cast.fromJson(c)).toList()
          : null,
      seasonDetails: (json['seasonDetails'] as List)
          .map((season) => SeasonDetail.fromJson(season))
          .toList(),
    );
  }
}

class Cast {
  final String name;
  final String role;
  final String image;

  Cast({
    required this.name,
    required this.role,
    required this.image,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      name: json['name'],
      role: json['role'],
      image: json['image'],
    );
  }
}

class SeasonDetail {
  final int seasonNumber;
  final String title;
  final String thumbnail;
  final String description;
  final String videoUrl;
  final List<Episode> episodes;

  SeasonDetail({
    required this.seasonNumber,
    required this.title,
    required this.thumbnail,
    required this.description,
    required this.videoUrl,
    required this.episodes,
  });

  factory SeasonDetail.fromJson(Map<String, dynamic> json) {
    return SeasonDetail(
      seasonNumber: json['seasonNumber'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      description: json['description'],
      videoUrl: json['videoUrl'],
      episodes: (json['episodes'] as List)
          .map((e) => Episode.fromJson(e))
          .toList(),
    );
  }
}

class Episode {
  final int episodeNumber;
  final String title;
  final String thumbnail;
  final String description;
  final String videoUrl;

  Episode({
    required this.episodeNumber,
    required this.title,
    required this.thumbnail,
    required this.description,
    required this.videoUrl,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      episodeNumber: json['episodeNumber'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      description: json['description'],
      videoUrl: json['videoUrl'],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> movies = [];
  List<Movie> recommendedMovies = [];
  List<Series> seriesList = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  // Enhanced Color Palette
  final Color darkBackground = const Color(0xFF232B2B);
  final Color cardDark = const Color(0xFF283634);
  final Color tealAccent = const Color(0xFF116466);
  final Color emerald = const Color(0xFF15847D);
  final Color mint = const Color(0xFFB8FFF9);
  final Color sandColor = const Color(0xFFD9B08C);
  final Color paleGreen = const Color(0xFFD1E8E2);
  final Color lightSand = const Color(0xFFFFCB9A);

  @override
  void initState() {
    super.initState();
    fetchMovies();
    fetchSeries();
  }

  Future<void> fetchMovies() async {
    final url = 'http://localhost:5000/api/movies'; // Use correct API URL
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          movies = data.map((movieData) {
            return Movie(
              title: movieData['title'] ?? 'Untitled',
              imageUrl: movieData['imageUrl'] ?? 'https://via.placeholder.com/150',
              genre: movieData['genre'] ?? 'Unknown',
              description: movieData['description'] ?? 'No description',
              videoUrl: movieData['videoUrl'] ?? '',
              movieUrl: movieData['movieUrl'] ?? '',
              director: movieData['director'],
              rating: movieData['rating'] != null
                  ? double.tryParse(movieData['rating'].toString())
                  : null,
              cast: movieData['cast'] != null
                  ? (movieData['cast'] as List)
                      .map((c) => MovieCast.fromJson(c))
                      .toList()
                  : null,
            );
          }).toList();
          loadRecommendedMovies();
          isLoading = false;
        });
      } else {
        print("Error fetching movies: ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Exception during fetchMovies: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchSeries() async {
    final url = 'http://localhost:5000/api/series';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          seriesList = data.map((seriesData) => Series.fromJson(seriesData)).toList();
        });
      } else {
        print("Error fetching series: ${response.statusCode}");
        setState(() => seriesList = []);
      }
    } catch (e) {
      print("Exception during fetchSeries: $e");
      setState(() => seriesList = []);
    }
  }


// Track genre when user watches a movie
Future<void> trackGenre(String genre) async {
  final prefs = await SharedPreferences.getInstance();
  int currentCount = prefs.getInt(genre) ?? 0;
  await prefs.setInt(genre, currentCount + 1);
  await loadRecommendedMovies(); // Update recommendations after tracking
}

// Get top genres from watch history
Future<List<String>> getTopGenres({int limit = 2}) async {
  final prefs = await SharedPreferences.getInstance();
  final Map<String, int> genreCounts = {};
  // List all possible genres in your app
  final List<String> genres = [
    'Action',
    'Drama',
    'Horror',
    'Comedy',
    'Thriller',
    'Sci-Fi',
    'Adventure',
  ];
  for (final genre in genres) {
    final count = prefs.getInt(genre) ?? 0;
    genreCounts[genre] = count;
  }
  final sortedEntries = genreCounts.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  // Only return genres with at least 1 watch
  return sortedEntries
      .where((e) => e.value > 0)
      .take(limit)
      .map((e) => e.key)
      .toList();
}

// Filter movies by top genres, or show all if no history
Future<void> loadRecommendedMovies() async {
  if (movies.isEmpty) return;
  final topGenres = await getTopGenres();
  setState(() {
    if (topGenres.isEmpty) {
      // No history: show all movies
      recommendedMovies = List<Movie>.from(movies);
    } else {
      // Show movies matching top genres
      recommendedMovies =
          movies.where((movie) => topGenres.contains(movie.genre)).toList();
      // If no movies match top genres, fallback to all movies
      if (recommendedMovies.isEmpty) {
        recommendedMovies = List<Movie>.from(movies);
      }
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: emerald))
            : ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 12),
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildPageView(movies, context),
                  const SizedBox(height: 22),
                  _buildSectionTitle("Genres"),
                  const SizedBox(height: 12),
                  _buildGenreList(),
                  const SizedBox(height: 22),
                  _buildSlider("Trending", movies, context),
                  _buildSlider("Recommended", recommendedMovies, context),
                  _buildSlider("Recently Added", movies, context),
                  const SizedBox(height: 18),
                  _buildSeriesSection(),
                  const SizedBox(height: 18),
                ],
              ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Material(
        color: cardDark,
        elevation: 3,
        borderRadius: BorderRadius.circular(32),
        child: TextField(
          controller: _searchController,
          style: TextStyle(color: mint, fontWeight: FontWeight.w500),
          textInputAction: TextInputAction.search,
          onSubmitted: (query) {
            if (query.trim().isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchResultsPage(
                    searchQuery: query,
                    movies: movies,
                  ),
                ),
              );
            }
          },
          decoration: InputDecoration(
            hintText: 'Search movies, shows...',
            hintStyle: TextStyle(color: paleGreen.withOpacity(0.7)),
            prefixIcon: Icon(Icons.search, color: emerald),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              gradient: LinearGradient(
                colors: [emerald, tealAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              color: mint,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
              shadows: [
                Shadow(
                  color: emerald.withOpacity(0.15),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageView(List<Movie> movies, BuildContext context) {
    return SizedBox(
      height: 260,
      child: PageView.builder(
        itemCount: movies.length,
        controller: PageController(viewportFraction: 0.78),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () {
              trackGenre(movie.genre);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie)),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: LinearGradient(
                        colors: [tealAccent.withOpacity(0.12), cardDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: emerald.withOpacity(0.16),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Hero(
                        tag: movie.title,
                        child: Image.network(
                          movie.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 260,
                          loadingBuilder: (context, child, progress) {
                            return progress == null
                                ? child
                                : Center(
                                    child: CircularProgressIndicator(color: emerald),
                                  );
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.vertical(bottom: Radius.circular(22)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            cardDark.withOpacity(0.95),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        movie.title,
                        style: TextStyle(
                          color: mint,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: emerald.withOpacity(0.2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGenreList() {
    final genres = [
      {
        'icon': FontAwesomeIcons.bolt,
        'label': 'Action',
        'bgColor': Colors.redAccent,
        'iconColor': Colors.white,
      },
      {
        'icon': FontAwesomeIcons.theaterMasks,
        'label': 'Drama',
        'bgColor': Colors.deepPurpleAccent,
        'iconColor': Colors.white,
      },
      {
        'icon': FontAwesomeIcons.ghost,
        'label': 'Horror',
        'bgColor': Colors.black87,
        'iconColor': Colors.deepOrangeAccent,
      },
      {
        'icon': FontAwesomeIcons.laughBeam,
        'label': 'Comedy',
        'bgColor': Colors.yellow.shade700,
        'iconColor': Colors.black87,
      },
      {
        'icon': FontAwesomeIcons.userNinja,
        'label': 'Thriller',
        'bgColor': Colors.teal,
        'iconColor': Colors.white,
      },
      {
        'icon': FontAwesomeIcons.robot,
        'label': 'Sci-Fi',
        'bgColor': Colors.indigo,
        'iconColor': Colors.cyanAccent,
      },
      {
        'icon': FontAwesomeIcons.mountainSun,
        'label': 'Adventures',
        'bgColor': Colors.green,
        'iconColor': Colors.white,
      },
    ];

    return SizedBox(
      height: 92,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: genres.length,
        itemBuilder: (context, index) {
          return _buildGenreItem(
            genres[index]['icon'] as IconData,
            genres[index]['label'] as String,
            genres[index]['bgColor'] as Color,
            genres[index]['iconColor'] as Color,
            context,
          );
        },
      ),
    );
  }

  Widget _buildGenreItem(
    IconData icon,
    String label,
    Color bgColor,
    Color iconColor,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GenreMovieListPage(
              genre: label,
              allMovies: movies,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 14),
        child: Column(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bgColor,
                boxShadow: [
                  BoxShadow(
                    color: bgColor.withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: FaIcon(icon, color: iconColor, size: 26),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String title, List<Movie> items, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Text(
            title,
            style: TextStyle(
              color: emerald,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: emerald.withOpacity(0.18),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return GestureDetector(
                onTap: () {
                  trackGenre(item.genre);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MovieDetailPage(movie: item)),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 14),
                  width: 145,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [cardDark, tealAccent.withOpacity(0.18)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          item.imageUrl,
                          height: 140,
                          width: 145,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          item.title,
                          style: TextStyle(
                            color: mint,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSeriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Series"),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            itemCount: seriesList.length,
            itemBuilder: (context, index) {
              final series = seriesList[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SeriesDetailPage(series: series)),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 14),
                  width: 145,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [cardDark, tealAccent.withOpacity(0.18)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          series.imageUrl,
                          height: 140,
                          width: 145,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          series.title,
                          style: TextStyle(
                            color: mint,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
