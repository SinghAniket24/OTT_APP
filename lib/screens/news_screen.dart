import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../news_service.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<dynamic>> newsList;

  // Custom color palette
  final Color darkBackground = const Color.fromARGB(255, 41, 48, 45);
  final Color tealAccent = const Color(0xFF116466);
  final Color sandColor = const Color(0xFFD9B08C);
  final Color lightSand = const Color(0xFFFFCB9A);
  final Color paleGreen = const Color(0xFFD1E8E2);

  @override
  void initState() {
    super.initState();
    newsList = NewsService().fetchEntertainmentNews();
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch $url'),
          backgroundColor: tealAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      // appBar: AppBar(
      //   title: const Text(
      //     'Quick Reads',
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       letterSpacing: 1.2,
      //     ),
      //   ),
      //   backgroundColor: tealAccent,
      //   elevation: 0,
      // ),
      body: FutureBuilder<List<dynamic>>(
        future: newsList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: tealAccent),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No news available',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final articles = snapshot.data!;
          final visibleArticles =
              articles.length > 5 ? articles.sublist(0, 5) : articles;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            itemCount: visibleArticles.length,
            itemBuilder: (context, index) {
              final news = visibleArticles[index];
              final imageUrl =
                  news['image_url'] ?? 'https://via.placeholder.com/400x200';
              final title = news['title'] ?? 'No title';
              final summary = news['description'] ?? 'No description';
              final articleUrl = news['link'] ?? 'https://example.com';

              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: index % 2 == 0
                      ? tealAccent.withOpacity(0.1)
                      : darkBackground,
                  border: Border.all(color: tealAccent.withOpacity(0.3), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: tealAccent.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => _launchURL(articleUrl),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.network(
                          imageUrl,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 200,
                            color: tealAccent.withOpacity(0.2),
                            child: Center(
                              child: Image.asset(
                                'error.jpg', // Place your default image in assets
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 200,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 2,
                            width: 60,
                            color: sandColor,
                            margin: EdgeInsets.only(bottom: 12),
                          ),
                          Text(
                            summary,
                            style: TextStyle(
                              fontSize: 14,
                              color: paleGreen,
                              height: 1.5,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () => _launchURL(articleUrl),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: sandColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: sandColor, width: 1),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Read more',
                                    style: TextStyle(
                                      color: sandColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 16,
                                    color: sandColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
