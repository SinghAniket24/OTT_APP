import 'dart:async';
import 'package:flutter/material.dart';
import 'movie_detail_page.dart';
import 'home_screen.dart'; // For Movie class

class SearchResultsPage extends StatefulWidget {
  final String searchQuery;
  final List<Movie> movies; // Passed from home_screen.dart

  const SearchResultsPage({
    Key? key,
    required this.searchQuery,
    required this.movies,
  }) : super(key: key);

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> with TickerProviderStateMixin {
  List<Movie> searchResults = [];
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  final Color darkBackground = Color.fromARGB(255, 36, 41, 39);
  final Color tealAccent = Color(0xFF116466);
  final Color sandColor = Color(0xFFD9B08C);
  final Color lightSand = Color(0xFFFFCB9A);
  final Color paleGreen = Color(0xFFD1E8E2);

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery;
    _searchController.addListener(_onSearchChanged);
    _filterLocalMovies(widget.searchQuery);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: 400), () {
      final query = _searchController.text.trim();
      if (query.isNotEmpty) {
        _filterLocalMovies(query);
      } else {
        setState(() => searchResults = []);
      }
    });
  }

  void _filterLocalMovies(String query) {
    final lowerQuery = query.toLowerCase();
    final filtered = widget.movies.where((movie) {
      return movie.title.toLowerCase().contains(lowerQuery) ||
             movie.genre.toLowerCase().contains(lowerQuery);
    }).toList();

    setState(() {
      searchResults = filtered;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Widget buildMovieCard(Movie movie, int index) {
    AnimationController controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500 + index * 100),
    );
    Animation<double> fade = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();

    return FadeTransition(
      opacity: fade,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie)),
          );
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: sandColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: paleGreen.withOpacity(0.4),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Hero(
                tag: movie.title,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                  child: Image.network(
                    movie.imageUrl,
                    width: 110,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: paleGreen),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6),
                      Text(movie.genre, style: TextStyle(fontSize: 14, color: lightSand)),
                      SizedBox(height: 8),
                      Text("Tap to view details",
                          style: TextStyle(color: lightSand.withOpacity(0.7), fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(title: Text('Search Results'), backgroundColor: tealAccent),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: lightSand),
                decoration: InputDecoration(
                  hintText: 'Search movies or series...',
                  hintStyle: TextStyle(color: paleGreen.withOpacity(0.6)),
                  filled: true,
                  fillColor: Colors.black12,
                  prefixIcon: Icon(Icons.search, color: paleGreen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: searchResults.isEmpty
                  ? Center(child: Text("No results found", style: TextStyle(color: lightSand)))
                  : ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) =>
                          buildMovieCard(searchResults[index], index),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
