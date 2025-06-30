import 'package:flutter/material.dart';
import 'dart:ui';
import 'video_player.dart';
import 'cast_screen.dart';
import 'library_page.dart';
import 'watchlist_manager.dart';
import 'home_screen.dart'; // for Series class

class SeriesDetailPage extends StatefulWidget {
  final Series series;

  const SeriesDetailPage({super.key, required this.series});

  @override
  _SeriesDetailPageState createState() => _SeriesDetailPageState();
}


class _SeriesDetailPageState extends State<SeriesDetailPage> with SingleTickerProviderStateMixin {
  bool _isVideoPlaying = false;
  String? _currentVideoUrl;
  

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  // final String creatorName = "Vince Gilligan";
  final List<String> castList = ["Bryan Cranston", "Aaron Paul", "Anna Gunn", "Dean Norris"];

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

  // double _getRating() {
  //   return (5 + (DateTime.now().millisecondsSinceEpoch % 50) / 10);
  // }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playVideo(String videoUrl) {
    setState(() {
      _isVideoPlaying = true;
      _currentVideoUrl = videoUrl;
    });
  }

  void _closeVideo() {
    setState(() {
      _isVideoPlaying = false;
      _currentVideoUrl = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    double? rating = widget.series.rating;
    final isInWatchlist = WatchlistManager().isSeriesInWatchlist(widget.series);
    String? director = widget.series.director;
    List<Cast>? castList = widget.series.cast;

    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        backgroundColor: cardDark,
        title: Text(
          widget.series.title,
          style: TextStyle(
            color: accentTeal,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.2,
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
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Top Video or Poster ---
                Padding(
                  padding: const EdgeInsets.only(top: 18, left: 18, right: 18),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: (_isVideoPlaying && _currentVideoUrl != null)
                        ? Stack(
                            key: ValueKey(_currentVideoUrl),
                            children: [
                              MovieVideoPlayer(
                                key: ValueKey(_currentVideoUrl),
                                videoUrl: _currentVideoUrl!,
                              ),
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Material(
                                  color: Colors.black45,
                                  shape: const CircleBorder(),
                                  child: IconButton(
                                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                                    onPressed: _closeVideo,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Stack(
                            key: const ValueKey('poster'),
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: Container(
                                  height: 240,
                                  width: double.infinity,
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
                                          widget.series.imageUrl,
                                          fit: BoxFit.cover,
                                          color: Colors.black.withOpacity(0.33),
                                          colorBlendMode: BlendMode.darken,
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                                          child: Container(
                                            color: Colors.black.withOpacity(0.07),
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(14),
                                          child: Image.network(
                                            widget.series.imageUrl,
                                            width: 150,
                                            height: 200,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => Container(
                                              width: 150,
                                              height: 200,
                                              color: cardDark,
                                              child: const Icon(Icons.broken_image, color: Colors.white38, size: 60),
                                            ),
                                            loadingBuilder: (context, child, progress) {
                                              if (progress == null) return child;
                                              return Container(
                                                width: 150,
                                                height: 200,
                                                color: cardDark,
                                                child: const Center(child: CircularProgressIndicator()),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      // Play button overlay
                                      Positioned.fill(
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: GestureDetector(
                                            onTap: () => _playVideo(widget.series.videoUrl),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.13),
                                                borderRadius: BorderRadius.circular(60),
                                                border: Border.all(color: accentTeal.withOpacity(0.3), width: 2),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: accentTeal.withOpacity(0.2),
                                                    blurRadius: 20,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              padding: const EdgeInsets.all(18),
                                              child: Icon(Icons.play_circle_fill, color: accentAmber, size: 54),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                // --- Series Info Section ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.series.title,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Chip(
                            backgroundColor: chipBg,
                            label: Text(
                              widget.series.genre,
                              style: TextStyle(color: accentTeal, fontWeight: FontWeight.w600),
                            ),
                            side: BorderSide(color: accentTeal, width: 1),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          const SizedBox(width: 12),
                          Row(
                            children: [
                              Icon(Icons.star, color: accentAmber, size: 20),
                              const SizedBox(width: 2),
                              Text(
  rating != null ? '${rating.toStringAsFixed(1)} / 10' : 'N/A',
  style: TextStyle(fontSize: 18, color: accentAmber, fontWeight: FontWeight.w600),
),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        widget.series.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: textSecondary,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                // --- Action Buttons Row ---
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
                          onPressed: () => _playVideo(widget.series.videoUrl),
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
                const SizedBox(height: 12),

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
                          WatchlistManager().addSeries(widget.series);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Added to Watchlist!"),
                              backgroundColor: accentGreen,
                            ),
                          );
                        } else {
                          WatchlistManager().removeSeries(widget.series);
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
                const SizedBox(height: 24),

                // --- Creator & Cast Section ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Row(
  children: [
    Icon(Icons.tv, color: accentTeal, size: 22),
    const SizedBox(width: 8),
    Text(
      "Director: ",
      style: TextStyle(fontWeight: FontWeight.bold, color: textPrimary, fontSize: 16),
    ),
    Text(
      director != null && director.isNotEmpty ? director : 'Unknown',
      style: TextStyle(color: textSecondary, fontSize: 16),
    ),
  ],
),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.groups, color: accentTeal, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            "Cast",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                     
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: (castList ?? []).map((castMember) {
      return Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Chip(
          backgroundColor: chipBg,
          side: BorderSide(color: accentTeal, width: 1),
          label: Row(
            children: [
              castMember.image.isNotEmpty
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(castMember.image),
                      radius: 14,
                      backgroundColor: Colors.transparent,
                    )
                  : Icon(Icons.person, color: accentTeal, size: 22),
              const SizedBox(width: 7),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    castMember.name,
                    style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    castMember.role,
                    style: TextStyle(color: textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        ),
      );
    }).toList(),
  ),
),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // --- All Seasons & Episodes Section ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Text(
                    "All Seasons & Episodes",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: accentTeal,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // --- Seasons and Episodes ---
                ...widget.series.seasonDetails.map((season) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: cardDark,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: accentTeal.withOpacity(0.09),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Season Title and Thumbnail
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      season.thumbnail,
                                      width: 90,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        width: 90,
                                        height: 120,
                                        color: bgDark,
                                        child: Icon(Icons.broken_image, color: accentTeal, size: 36),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 18),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          season.title,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: accentAmber,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          season.description,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: textSecondary,
                                          ),
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              // Episodes List
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: season.episodes.length,
                                separatorBuilder: (context, idx) => Divider(
                                  color: accentTeal.withOpacity(0.08),
                                  height: 18,
                                ),
                                itemBuilder: (context, epiIdx) {
                                  final episode = season.episodes[epiIdx];
                                  return InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () => _playVideo(episode.videoUrl),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                      decoration: BoxDecoration(
                                        color: bgDark,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: accentTeal.withOpacity(0.13), width: 1),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(
                                              episode.thumbnail,
                                              width: 70,
                                              height: 70,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => Container(
                                                width: 70,
                                                height: 70,
                                                color: cardDark,
                                                child: Icon(Icons.broken_image, color: accentTeal, size: 28),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Episode ${episode.episodeNumber}: ${episode.title}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: accentTeal,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  episode.description,
                                                  style: TextStyle(
                                                    color: textSecondary,
                                                    fontSize: 14,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(Icons.play_circle_fill, color: accentAmber, size: 28),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
