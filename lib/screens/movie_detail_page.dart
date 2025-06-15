import 'package:flutter/material.dart';
import 'video_player.dart';
import 'cast_screen.dart';
import 'library_page.dart';
import 'watchlist_manager.dart';
import 'dart:ui';
import 'home_screen.dart'; // Make sure Movie class is imported

enum PlayingVideoType { none, movie, trailer }

class MovieDetailPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> with SingleTickerProviderStateMixin {
  PlayingVideoType _playingVideoType = PlayingVideoType.none;
  bool _isLiked = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

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

  void _stopPlaying() {
    setState(() {
      _playingVideoType = PlayingVideoType.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    double? rating = widget.movie.rating;
    final isInWatchlist = WatchlistManager().isInWatchlist(widget.movie);
    List<MovieCast>? castList = widget.movie.cast;

    String? videoUrl;
    String videoTitle = '';
    if (_playingVideoType == PlayingVideoType.movie) {
      videoUrl = widget.movie.movieUrl;
      videoTitle = 'Now Playing';
    } else if (_playingVideoType == PlayingVideoType.trailer) {
      videoUrl = widget.movie.videoUrl;
      videoTitle = 'Trailer';
    }

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Video Player or Poster
                if (_playingVideoType != PlayingVideoType.none && videoUrl != null && videoUrl.isNotEmpty)
                  Stack(
                    children: [
                      MovieVideoPlayer(videoUrl: videoUrl),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: GestureDetector(
                          onTap: _stopPlaying,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(Icons.close, color: Colors.white, size: 28),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            videoTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else
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
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.network(
                                widget.movie.imageUrl,
                                fit: BoxFit.cover,
                                color: Colors.black.withOpacity(0.4),
                                colorBlendMode: BlendMode.darken,
                              ),
                            ),
                            Positioned.fill(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                                child: Container(color: Colors.transparent),
                              ),
                            ),
                            Center(
                              child: Image.network(
                                widget.movie.imageUrl,
                                width: double.infinity,
                                height: 260,
                                fit: BoxFit.contain,
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
                          ],
                        ),
                      ),
                    ),
                  ),
                // Title
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
                // Genre chip & Rating
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
                                rating != null ? '${rating.toStringAsFixed(1)} / 10' : 'N/A',
                                style: TextStyle(fontSize: 18, color: accentAmber),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Like Button
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
                const SizedBox(height: 18),
                // BUTTONS GROUPED
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentTeal,
                                foregroundColor: textPrimary,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                elevation: 8,
                              ),
                              onPressed: widget.movie.movieUrl != null && widget.movie.movieUrl!.isNotEmpty
                                  ? () {
                                      setState(() {
                                        _playingVideoType = PlayingVideoType.movie;
                                      });
                                    }
                                  : null,
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
                                backgroundColor: accentTeal.withOpacity(0.9),
                                foregroundColor: textPrimary,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                elevation: 8,
                              ),
                              onPressed: widget.movie.videoUrl.isNotEmpty
                                  ? () {
                                      setState(() {
                                        _playingVideoType = PlayingVideoType.trailer;
                                      });
                                    }
                                  : null,
                              icon: const Icon(Icons.ondemand_video, size: 24),
                              label: const Text(
                                'Watch Trailer',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cardDark,
                          foregroundColor: accentTeal,
                          padding: const EdgeInsets.symmetric(vertical: 16),
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
                      const SizedBox(height: 14),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isInWatchlist ? accentGreen : accentAmber,
                          foregroundColor: textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 15),
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
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                // About the Movie
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Text(
                    "About the Movie",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: accentTeal,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Text(
                    widget.movie.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                // Director
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
                        widget.movie.director != null && widget.movie.director!.isNotEmpty
                            ? widget.movie.director!
                            : 'Unknown',
                        style: TextStyle(color: textSecondary, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // Cast Section (unchanged)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Text(
                    "Cast",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: accentTeal,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (castList != null && castList.isNotEmpty)
                  SizedBox(
                    height: 110,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      itemCount: castList.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 18),
                      itemBuilder: (context, index) {
                        final cast = castList[index];
                        return Column(
                          children: [
                            ClipOval(
                              child: Image.network(
                                cast.image,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 60,
                                  height: 60,
                                  color: cardDark,
                                  child: const Icon(Icons.person, color: Colors.white54, size: 32),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              cast.name,
                              style: TextStyle(
                                color: textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              cast.role,
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Text(
                      "No cast information available.",
                      style: TextStyle(color: textSecondary, fontSize: 14),
                    ),
                  ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
