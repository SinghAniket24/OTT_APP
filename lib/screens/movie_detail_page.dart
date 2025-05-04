import 'package:flutter/material.dart';
import 'video_player.dart';
import 'cast_screen.dart';
import 'library_page.dart';
import 'watchlist_manager.dart';

class MovieDetailPage extends StatefulWidget {
  final movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> with SingleTickerProviderStateMixin {
  bool _isVideoPlaying = false;
  bool _isLiked = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  double _getRating() {
    return (5 * (1 + (DateTime.now().millisecondsSinceEpoch % 100) / 100)).toDouble();
  }

  final String directorName = "Christopher Nolan";
  final List<String> castList = ["Leonardo DiCaprio", "Joseph Gordon-Levitt", "Elliot Page", "Tom Hardy"];

  // --- Reference UI Colors ---
  final Color bgDark = const Color(0xFF181F2B);
  final Color cardDark = const Color(0xFF232B3E);
  final Color accentTeal = const Color(0xFF00B4D8);
  final Color accentAmber = const Color(0xFFFFC300);
  final Color accentRed = const Color(0xFFE63946);
  final Color accentGreen = const Color(0xFF43AA8B);
  final Color textPrimary = Colors.white;
  final Color textSecondary = Colors.white70;
  final Color chipBg = const Color(0xFF29324A);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double rating = _getRating();

    final isInWatchlist = WatchlistManager().isInWatchlist(widget.movie);

    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        backgroundColor: cardDark,
        title: Text(
          widget.movie.title,
          style: TextStyle(
            color: accentTeal,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: accentTeal),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.library_books, color: accentTeal),
            tooltip: 'Watchlist',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LibraryPage()),
              );
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isVideoPlaying)
                MovieVideoPlayer(
                  videoUrl: "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4",
                ),
              if (!_isVideoPlaying)
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: accentTeal.withOpacity(0.13),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Image.network(
                        widget.movie.imageUrl,
                        width: double.infinity,
                        height: 260,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: double.infinity,
                          height: 260,
                          color: cardDark,
                          child: const Center(
                            child: Icon(Icons.broken_image, color: Colors.white38, size: 60),
                          ),
                        ),
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            width: double.infinity,
                            height: 260,
                            color: cardDark,
                            child: const Center(child: CircularProgressIndicator()),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Text(
                  widget.movie.title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                      backgroundColor: chipBg,
                      label: Text(
                        widget.movie.genre,
                        style: TextStyle(color: accentTeal, fontWeight: FontWeight.w600),
                      ),
                      side: BorderSide(color: accentTeal, width: 1),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Rating', style: TextStyle(fontSize: 12, color: textSecondary)),
                        Row(
                          children: [
                            Icon(Icons.star, color: accentAmber, size: 18),
                            const SizedBox(width: 3),
                            Text(
                              '${rating.toStringAsFixed(1)} / 10',
                              style: TextStyle(fontSize: 18, color: accentAmber),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: GestureDetector(
                  onTap: () => setState(() => _isLiked = !_isLiked),
                  child: Row(
                    children: [
                      Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        color: _isLiked ? accentRed : accentAmber,
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isLiked ? 'Liked' : 'Like',
                        style: TextStyle(
                          color: _isLiked ? accentRed : textSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentTeal,
                          foregroundColor: textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          elevation: 8,
                        ),
                        onPressed: () {
                          setState(() {
                            _isVideoPlaying = true;
                          });
                        },
                        icon: const Icon(Icons.play_circle_fill, size: 26),
                        label: const Text(
                          'Watch Now',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cardDark,
                          foregroundColor: accentTeal,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          elevation: 8,
                          side: BorderSide(color: accentTeal, width: 1.2),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CastScreen()),
                          );
                        },
                        icon: const Icon(Icons.cast, size: 24),
                        label: const Text(
                          'Cast to TV',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // --- Watchlist Button ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isInWatchlist ? accentGreen : accentAmber,
                    foregroundColor: textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    elevation: 6,
                  ),
                  icon: Icon(
                    isInWatchlist ? Icons.check : Icons.add,
                    color: textPrimary,
                  ),
                  label: Text(
                    isInWatchlist ? "Added to Watchlist" : "Add to Watchlist",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  onPressed: () {
                    setState(() {
                      if (!isInWatchlist) {
                        WatchlistManager().addMovie(widget.movie);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Added to Watchlist!"),
                            backgroundColor: accentGreen,
                          ),
                        );
                      } else {
                        WatchlistManager().removeMovie(widget.movie);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Removed from Watchlist."),
                            backgroundColor: accentRed,
                          ),
                        );
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Row(
                  children: [
                    Icon(Icons.movie_creation_outlined, color: accentTeal, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      "Director: ",
                      style: TextStyle(fontWeight: FontWeight.bold, color: textPrimary, fontSize: 16),
                    ),
                    Text(
                      directorName,
                      style: TextStyle(color: textSecondary, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Row(
                  children: [
                    Icon(Icons.groups, color: accentTeal, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      "Cast",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textPrimary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // --- Horizontal cast chips ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: castList.map((cast) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Chip(
                          backgroundColor: chipBg,
                          side: BorderSide(color: accentTeal, width: 1),
                          label: Text(cast, style: TextStyle(color: textPrimary)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Text(
                  'About the Movie',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: accentTeal),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Text(
                  widget.movie.description,
                  style: TextStyle(fontSize: 16, height: 1.6, color: textSecondary),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
