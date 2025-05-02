import 'package:flutter/material.dart';
import 'movie_detail_page.dart';
import 'home_screen.dart';

class GenreMovieListPage extends StatelessWidget {
  final String genre;
  final List<Movie> allMovies;

  const GenreMovieListPage({
    super.key,
    required this.genre,
    required this.allMovies,
  });

  @override
  Widget build(BuildContext context) {
    final darkBackground = const Color.fromARGB(255, 36, 41, 39);
    final tealAccent = const Color(0xFF116466);
    final sandColor = const Color(0xFFD9B08C);
    final lightSand = const Color(0xFFFFCB9A);
    final paleGreen = const Color(0xFFD1E8E2);

    final filteredMovies =
        allMovies.where((movie) => movie.genre == genre).toList();

    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: darkBackground,
        title: Text(
          '$genre Movies',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: filteredMovies.isEmpty
          ? const Center(
              child: Text(
                'No movies found in this genre.',
                style: TextStyle(color: Colors.white),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                itemCount: filteredMovies.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final movie = filteredMovies[index];

                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.95, end: 1),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOutBack,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: _GlowingMovieCard(
                          movie: movie,
                          paleGreen: paleGreen,
                          tealAccent: tealAccent,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}

// Extracted glowing card widget
class _GlowingMovieCard extends StatefulWidget {
  final Movie movie;
  final Color paleGreen;
  final Color tealAccent;

  const _GlowingMovieCard({
    required this.movie,
    required this.paleGreen,
    required this.tealAccent,
  });

  @override
  State<_GlowingMovieCard> createState() => _GlowingMovieCardState();
}

class _GlowingMovieCardState extends State<_GlowingMovieCard> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() => _isTapped = true);
        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 800),
              pageBuilder: (_, __, ___) =>
                  MovieDetailPage(movie: widget.movie),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return ScaleTransition(
                  scale: CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOutBack,
                  ),
                  child: child,
                );
              },
            ),
          ).then((_) => setState(() => _isTapped = false));
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: widget.tealAccent.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isTapped
              ? [
                  BoxShadow(
                    color: widget.tealAccent.withOpacity(0.5),
                    blurRadius: 16,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(2, 4),
                  ),
                ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                widget.movie.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 180,
                  color: Colors.grey,
                  child: const Icon(Icons.broken_image, size: 40),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: widget.paleGreen,
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(12)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                child: Center(
                  child: Text(
                    widget.movie.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: widget.tealAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
