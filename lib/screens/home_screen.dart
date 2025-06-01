import 'package:flutter/material.dart';
import 'movie_detail_page.dart';
import 'series_detail_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'searchresuts.dart';
import 'genre_movie_screen.dart';

// Movie class
class Movie {
  final String title;
  final String imageUrl;
  final String genre;
  final String description;
  final String videoUrl;

  Movie({
    required this.title,
    required this.imageUrl,
    required this.genre,
    required this.description,
    required this.videoUrl,
  });
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

  Series({
    required this.title,
    required this.imageUrl,
    required this.genre,
    required this.description,
    required this.videoUrl,
    required this.seasons,
    required this.episodes,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> movies = [];
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
  final url = 'http://localhost:5000/api/movies'; // use localhost for Flutter Web
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
            description: movieData['synopsis'] ?? 'No description',
            videoUrl: movieData['videoUrl'] ?? '',
          );
        }).toList();
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


  // Updated: Fetch series from OMDb API
  Future<void> fetchSeries() async {
  final url = 'http://localhost:5000/api/series';
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        seriesList = data.map((seriesData) {
          return Series(
            title: seriesData['title'] ?? 'Untitled',
            imageUrl: seriesData['imageUrl'] ?? 'https://via.placeholder.com/150',
            genre: seriesData['genre'] ?? 'Unknown',
            description: seriesData['synopsis'] ?? 'No description',
            videoUrl: seriesData['videoUrl'] ?? '',
            seasons: seriesData['seasons'] ?? 0,
            episodes: seriesData['episodes'] ?? 0,
          );
        }).toList();
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
                  _buildSlider("Recommended", movies, context),
                  _buildSlider("Recently Added", movies, context),
                  const SizedBox(height: 18),
                  _buildSeriesSection(), // <---- Series Section Added Here
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
                  builder: (context) => SearchResultsPage(searchQuery: query),
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
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie)),
                );
              },
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
                                    child: CircularProgressIndicator(color: emerald));
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
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(22)),
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
      {'img': 'https://picsum.photos/200/200?random=101', 'label': 'Action'},
      {'img': 'https://picsum.photos/200/200?random=102', 'label': 'Drama'},
      {'img': 'https://picsum.photos/200/200?random=103', 'label': 'Horror'},
      {'img': 'https://picsum.photos/200/200?random=104', 'label': 'Comedy'},
      {'img': 'https://picsum.photos/200/200?random=105', 'label': 'Thriller'},
    ];
    return SizedBox(
      height: 92,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: genres.length,
        itemBuilder: (context, index) {
          return _buildGenreItem(genres[index]['img']!, genres[index]['label']!);
        },
      ),
    );
  }

  Widget _buildGenreItem(String imageUrl, String label) {
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
                gradient: LinearGradient(
                  colors: [emerald, tealAccent, cardDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: mint.withOpacity(0.22),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: mint,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    color: emerald.withOpacity(0.18),
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

  // The series section builder (unchanged, just for completeness)
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
