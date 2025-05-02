import 'package:flutter/material.dart';
import 'movie_detail_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'searchresuts.dart';
import 'genre_movie_screen.dart'; // Add this import

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> movies = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final url = 'http://www.omdbapi.com/?s=batman&apikey=e23f75c3';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['Response'] == 'True') {
        setState(() {
          movies = (data['Search'] as List).map((movieData) {
            return Movie(
              title: movieData['Title'],
              imageUrl: movieData['Poster'],
              genre: 'Action', // You can later make this dynamic
              description: 'N/A',
              videoUrl:
                  'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
            );
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  final Color darkBackground = Color.fromARGB(255, 36, 41, 39);
  final Color tealAccent = Color(0xFF116466);
  final Color sandColor = Color(0xFFD9B08C);
  final Color lightSand = Color(0xFFFFCB9A);
  final Color paleGreen = Color(0xFFD1E8E2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: tealAccent))
            : ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 10),
                  _buildSearchBar(),
                  const SizedBox(height: 10),
                  _buildPageView(movies, context),
                  const SizedBox(height: 20),
                  _buildSectionTitle("Genres"),
                  const SizedBox(height: 10),
                  _buildGenreList(),
                  const SizedBox(height: 20),
                  _buildSlider("Trending", movies, context),
                  _buildSlider("Recommended", movies, context),
                  _buildSlider("Recently Added", movies, context),
                ],
              ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
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
          hintStyle: TextStyle(color: paleGreen),
          prefixIcon: Icon(Icons.search, color: sandColor),
          filled: true,
          fillColor: tealAccent.withOpacity(0.1),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: TextStyle(
          color: sandColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPageView(List<Movie> movies, BuildContext context) {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        itemCount: movies.length,
        controller: PageController(viewportFraction: 0.8),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie)),
                );
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Hero(
                      tag: movie.title,
                      child: Image.network(
                        movie.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        loadingBuilder: (context, child, progress) {
                          return progress == null
                              ? child
                              : Center(
                                  child:
                                      CircularProgressIndicator(color: tealAccent));
                        },
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
                            BorderRadius.vertical(bottom: Radius.circular(20)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7)
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        movie.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
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
        padding: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [tealAccent.withOpacity(0.3), darkBackground],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: tealAccent.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
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
                color: paleGreen,
                fontSize: 13,
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            title,
            style: TextStyle(
              color: sandColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
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
                  margin: const EdgeInsets.only(right: 12),
                  width: 140,
                  decoration: BoxDecoration(
                    color: tealAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: tealAccent.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: tealAccent.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(18)),
                        child: Image.network(
                          item.imageUrl,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text(
                          item.title,
                          style: TextStyle(
                            color: paleGreen,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
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
