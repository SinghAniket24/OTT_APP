import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  final String _apiKey = 'pub_829027844f06266341c58f73c4dc2197f4d27'; // Replace with your actual API key
  final String _baseUrl = 'https://newsdata.io/api/1/news';

  // List of keywords related to movies, OTT, and TV shows
  final List<String> keywords = [
    'movie', 'film', 'cinema', 'netflix', 'amazon prime', 'disney+', 'ott',
    'actor', 'actress', 'hollywood', 'bollywood', 'web series', 'trailer',
    'tv show', 'season', 'episode', 'box office', 'imdb', 'review'
  ];

  Future<List<dynamic>> fetchEntertainmentNews() async {
    final response = await http.get(
      Uri.parse('$_baseUrl?category=entertainment&language=en&apikey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final allArticles = data['results'] ?? [];

      // Filter articles based on keywords related to movies, OTT, and TV shows
      final filteredArticles = allArticles.where((article) {
        final title = (article['title'] ?? '').toString().toLowerCase();
        final description = (article['description'] ?? '').toString().toLowerCase();
        return keywords.any((keyword) =>
            title.contains(keyword) || description.contains(keyword));
      }).toList();

      return filteredArticles;
    } else {
      throw Exception('Failed to load news: ${response.statusCode}');
    }
  }
}


// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class NewsService {
//   final String _apiKey = 'f78191cf8f9349bd88d2f5f2bfc7b374'; // Your NewsAPI.org API Key
//   final String _baseUrl = 'https://newsapi.org/v2/top-headlines';

//   final List<String> keywords = [
//     'movie', 'film', 'cinema', 'netflix', 'amazon prime', 'disney+', 'ott',
//     'actor', 'actress', 'hollywood', 'bollywood', 'web series', 'trailer',
//     'tv show', 'season', 'episode', 'box office', 'imdb', 'review'
//   ];

//   Future<List<dynamic>> fetchEntertainmentNews() async {
//     final response = await http.get(
//       Uri.parse('$_baseUrl?category=entertainment&language=en&apiKey=$_apiKey'),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final allArticles = data['articles'] ?? [];

//       final filteredArticles = allArticles.where((article) {
//         final title = (article['title'] ?? '').toString().toLowerCase();
//         final description = (article['description'] ?? '').toString().toLowerCase();
//         return keywords.any((keyword) =>
//             title.contains(keyword) || description.contains(keyword));
//       }).toList();

//       return filteredArticles;
//     } else {
//       throw Exception('Failed to load news: ${response.statusCode}');
//     }
//   }
// }

