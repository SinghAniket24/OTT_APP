import 'package:flutter/material.dart';
import 'movie_detail_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}

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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  final Color darkBackground = const Color.fromARGB(255, 36, 41, 39);
  final Color tealAccent = const Color(0xFF116466);
  final Color sandColor = const Color(0xFFD9B08C);
  final Color lightSand = const Color(0xFFFFCB9A);
  final Color paleGreen = const Color(0xFFD1E8E2);

  @override
  Widget build(BuildContext context) {
    final List<Movie> movies = List.generate(10, (index) => Movie(
          title: 'Show ${index + 1}',
          imageUrl: 'https://picsum.photos/200/300?random=$index',
          genre: 'Genre ${index % 5}',
          description: 'Description for movie ${index + 1}',
          videoUrl: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
        ));

    return Scaffold(
      backgroundColor: darkBackground,
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
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
            ),
            SizedBox(
              height: 200,
              child: PageView.builder(
                itemCount: movies.length,
                controller: PageController(viewportFraction: 0.9),
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MovieDetailPage(movie: movie),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          movie.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "Genres",
                style: TextStyle(
                  color: sandColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _buildGenreItem('https://picsum.photos/200/200?random=101', 'Action'),
                  _buildGenreItem('https://picsum.photos/200/200?random=102', 'Drama'),
                  _buildGenreItem('https://picsum.photos/200/200?random=103', 'Horror'),
                  _buildGenreItem('https://picsum.photos/200/200?random=104', 'Comedy'),
                  _buildGenreItem('https://picsum.photos/200/200?random=105', 'Thriller'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSlider("Trending", movies, context),
            _buildSlider("Recommended", movies, context),
            _buildSlider("Recently Added", movies, context),
          ],
        ),
      ),
    );
  }

  Widget _buildGenreItem(String imageUrl, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tealAccent.withOpacity(0.2),
            ),
            child: ClipOval(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
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
    );
  }

  Widget _buildSlider(String title, List<Movie> items, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
          child: Text(
            title,
            style: TextStyle(
              color: sandColor,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieDetailPage(movie: item),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 130,
                  decoration: BoxDecoration(
                    color: tealAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: tealAccent.withOpacity(0.4)),
                    boxShadow: [
                      BoxShadow(
                        color: tealAccent.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.network(
                          item.imageUrl,
                          height: 160,
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
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      )
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
