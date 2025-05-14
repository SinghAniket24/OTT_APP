import 'package:flutter/material.dart';
import 'watchlist_manager.dart';
import 'movie_detail_page.dart';
import 'series_detail_page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  bool _isLoading = true;

  // Color palette
  final Color darkBackground = const Color(0xFF181F2B);
  final Color cardDark = const Color(0xFF232B3E);
  final Color accentTeal = const Color(0xFF00B4D8);
  final Color accentAmber = const Color(0xFFFFC300);
  final Color accentRed = const Color(0xFFE63946);
  final Color textPrimary = Colors.white;
  final Color textSecondary = Colors.white70;
  final Color chipBg = const Color(0xFF29324A);

  @override
  void initState() {
    super.initState();
    _loadWatchlist();
  }

  Future<void> _loadWatchlist() async {
    await WatchlistManager().loadWatchlist();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final movieWatchlist = WatchlistManager().movieWatchlist;
    final seriesWatchlist = WatchlistManager().seriesWatchlist;

    final List<Map<String, dynamic>> allItems = [
      ...movieWatchlist.map((m) => {'type': 'movie', 'item': m}),
      ...seriesWatchlist.map((s) => {'type': 'series', 'item': s}),
    ];

    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: cardDark,
        title: Text(
          "My Watchlist",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: accentTeal,
          ),
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : allItems.isEmpty
              ? Center(
                  child: Text(
                    "Your watchlist is empty.",
                    style: TextStyle(fontSize: 18, color: textSecondary),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView.builder(
                    itemCount: allItems.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.53, // Taller cards for more text space!
                    ),
                    itemBuilder: (context, index) {
                      final entry = allItems[index];
                      final type = entry['type'];
                      final item = entry['item'];

                      final String badgeText = type == 'movie' ? "Movie" : "Series";
                      final Color badgeColor = type == 'movie' ? accentTeal : accentAmber;

                      return Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(22),
                        elevation: 8,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(22),
                          onTap: () {
                            if (type == 'movie') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailPage(movie: item),
                                ),
                              ).then((_) => setState(() {}));
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SeriesDetailPage(series: item),
                                ),
                              ).then((_) => setState(() {}));
                            }
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                              color: cardDark,
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: badgeColor.withOpacity(0.10),
                                  blurRadius: 14,
                                  offset: Offset(0, 7),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Image with gradient overlay
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 170,
                                            width: double.infinity,
                                            color: chipBg,
                                          ),
                                          Image.network(
                                            item.imageUrl,
                                            height: 170,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => Container(
                                              height: 170,
                                              color: cardDark,
                                              child: const Center(
                                                child: Icon(Icons.broken_image, color: Colors.white38, size: 60),
                                              ),
                                            ),
                                            loadingBuilder: (context, child, progress) {
                                              if (progress == null) return child;
                                              return Container(
                                                height: 170,
                                                color: cardDark,
                                                child: const Center(child: CircularProgressIndicator()),
                                              );
                                            },
                                          ),
                                          // Gradient overlay at bottom for text contrast
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              height: 48,
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(22)),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.transparent,
                                                    cardDark.withOpacity(0.93),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Title and badge
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(height: 2),
                                            // Title with more space
                                            Expanded(
                                              child: Text(
                                                item.title,
                                                textAlign: TextAlign.center,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: textPrimary,
                                                  letterSpacing: 0.3,
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.black.withOpacity(0.13),
                                                      blurRadius: 2,
                                                      offset: Offset(1, 1),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: badgeColor.withOpacity(0.19),
                                                borderRadius: BorderRadius.circular(7),
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              child: Text(
                                                badgeText,
                                                style: TextStyle(
                                                  color: badgeColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            if (type == 'series') ...[
                                              const SizedBox(height: 4),
                                              Text(
                                                "${item.seasons} seasons",
                                                style: TextStyle(
                                                  color: textSecondary,
                                                  fontSize: 12,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Delete button at top right
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Tooltip(
                                    message: "Remove from Watchlist",
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (type == 'movie') {
                                            WatchlistManager().removeMovie(item);
                                          } else {
                                            WatchlistManager().removeSeries(item);
                                          }
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Removed from Watchlist.")),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.black38,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: const Icon(
                                          Icons.delete_outline,
                                          size: 20,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
