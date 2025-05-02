// import 'package:flutter/material.dart';
// import 'video_player.dart'; // Importing your custom video player

// class VideoPlayerScreen extends StatelessWidget {
//   final String videoUrl;

//   const VideoPlayerScreen({super.key, required this.videoUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Movie Player"),
//         backgroundColor: Colors.black,
//       ),
//       body: Center(
//         child: MovieVideoPlayer(
//           videoUrl: videoUrl, // Passing the video URL to your custom player
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'video_player_screen.dart'; // New page for video playback
// import 'cast_screen.dart';

// class MovieDetailPage extends StatefulWidget {
//   final movie;

//   const MovieDetailPage({super.key, required this.movie});

//   @override
//   _MovieDetailPageState createState() => _MovieDetailPageState();
// }

// class _MovieDetailPageState extends State<MovieDetailPage> {
//   bool _isLiked = false;

//   double _getRating() {
//     return (5 * (1 + (DateTime.now().millisecondsSinceEpoch % 100) / 100)).toDouble();
//   }

//   final String directorName = "Christopher Nolan";
//   final List<String> castList = ["Leonardo DiCaprio", "Joseph Gordon-Levitt", "Elliot Page", "Tom Hardy"];

//   @override
//   Widget build(BuildContext context) {
//     final Color darkBackground = const Color(0xFF222831);
//     final Color tealAccent = const Color(0xFF00ADB5);
//     final Color sandColor = const Color(0xFFEEEEEE);
//     final Color highlightColor = const Color(0xFFFF5722);
//     final Color secondaryTextColor = Colors.white70;

//     double rating = _getRating();

//     return Scaffold(
//       backgroundColor: darkBackground,
//       appBar: AppBar(
//         backgroundColor: tealAccent,
//         title: Text(
//           widget.movie.title,
//           style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
//         ),
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.white),
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: Image.network(
//                   widget.movie.imageUrl,
//                   width: double.infinity,
//                   height: 280,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Text(
//                 widget.movie.title,
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: sandColor,
//                   letterSpacing: 0.8,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Chip(
//                     backgroundColor: tealAccent.withOpacity(0.3),
//                     label: Text(
//                       widget.movie.genre,
//                       style: TextStyle(color: tealAccent, fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       const Text('Rating', style: TextStyle(fontSize: 12, color: Colors.white60)),
//                       Text(
//                         '${rating.toStringAsFixed(1)} / 10.0',
//                         style: const TextStyle(fontSize: 18, color: Colors.amber),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: GestureDetector(
//                 onTap: () => setState(() => _isLiked = !_isLiked),
//                 child: Row(
//                   children: [
//                     Icon(
//                       _isLiked ? Icons.favorite : Icons.favorite_border,
//                       color: _isLiked ? Colors.red : Colors.white,
//                       size: 30,
//                     ),
//                     const SizedBox(width: 10),
//                     Text(
//                       _isLiked ? 'Liked' : 'Like',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: highlightColor,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//                         elevation: 6,
//                       ),
//                       onPressed: () {
//                         // Navigate to the video player page
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => VideoPlayerScreen(
//                               videoUrl: "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4",
//                             ),
//                           ),
//                         );
//                       },
//                       icon: const Icon(Icons.play_circle_fill, size: 26, color: Colors.white),
//                       label: const Text(
//                         'Watch Now',
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.deepPurple,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//                         elevation: 6,
//                       ),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => const CastScreen()),
//                         );
//                       },
//                       icon: const Icon(Icons.cast, size: 24, color: Colors.white),
//                       label: const Text(
//                         'Cast to TV',
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 30),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 children: [
//                   const Icon(Icons.movie_creation_outlined, color: Colors.white70),
//                   const SizedBox(width: 8),
//                   Text(
//                     "Director: ",
//                     style: TextStyle(fontWeight: FontWeight.bold, color: sandColor, fontSize: 16),
//                   ),
//                   Text(
//                     directorName,
//                     style: TextStyle(color: secondaryTextColor, fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 children: const [
//                   Icon(Icons.groups, color: Colors.white70),
//                   SizedBox(width: 8),
//                   Text(
//                     "Cast",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 8),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Wrap(
//                 spacing: 10,
//                 runSpacing: 8,
//                 children: castList.map((cast) {
//                   return Chip(
//                     backgroundColor: darkBackground,
//                     side: BorderSide(color: tealAccent),
//                     label: Text(cast, style: TextStyle(color: sandColor)),
//                   );
//                 }).toList(),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Text(
//                 'About the Movie',
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: tealAccent),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Text(
//                 widget.movie.description,
//                 style: TextStyle(fontSize: 16, height: 1.6, color: secondaryTextColor),
//               ),
//             ),
//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }
// }
