import 'package:flutter/material.dart';
import 'home_screen.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    // Theme Colors
    final Color darkBackground = const Color.fromARGB(255, 36, 41, 39);
    final Color tealAccent = const Color(0xFF116466);
    final Color sandColor = const Color(0xFFD9B08C);
    final Color lightSand = const Color(0xFFFFCB9A);
    final Color paleGreen = const Color(0xFFD1E8E2);

    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: tealAccent,
        title: Text(
          movie.title,
          style: TextStyle(
            color: paleGreen,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: paleGreen),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster with Padding
            Padding(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: Image.network(
                  movie.imageUrl,
                  width: double.infinity,
                  height: 280,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Content Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    movie.title,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: sandColor,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Genre Chip
                  Chip(
                    backgroundColor: lightSand,
                    label: Text(
                      movie.genre,
                      style: TextStyle(
                        color: darkBackground,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // About the Movie
                  Text(
                    'About the Movie',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: paleGreen,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Description
                  Text(
                    movie.description,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: paleGreen.withOpacity(0.85),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Watch Now Button
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tealAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 8,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Feature coming soon!'),
                            backgroundColor: Colors.black87,
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_circle_fill, color: Colors.white, size: 28),
                      label: const Text(
                        'Watch Now',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
