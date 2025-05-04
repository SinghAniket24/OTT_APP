import 'package:flutter/material.dart';

// If you want to avoid duplicate Series class, you can import it from home.dart instead.
class Series {
  final String title;
  final String imageUrl;
  final String genre;
  final String description;

  Series({
    required this.title,
    required this.imageUrl,
    required this.genre,
    required this.description,
  });
}

class SeriesDetailPage extends StatelessWidget {
  final Series series;

  const SeriesDetailPage({Key? key, required this.series}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color emerald = const Color(0xFF15847D);
    final Color mint = const Color(0xFFB8FFF9);
    final Color cardDark = const Color(0xFF283634);

    return Scaffold(
      backgroundColor: const Color(0xFF232B2B),
      appBar: AppBar(
        backgroundColor: cardDark,
        title: Text(series.title, style: TextStyle(color: mint)),
        iconTheme: IconThemeData(color: emerald),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              series.imageUrl,
              height: 260,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            series.title,
            style: TextStyle(
              color: mint,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            series.genre,
            style: TextStyle(
              color: emerald,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            series.description,
            style: TextStyle(
              color: mint.withOpacity(0.85),
              fontSize: 17,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
