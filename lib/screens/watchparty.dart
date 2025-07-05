import 'package:flutter/material.dart';
import 'chat_room.dart';
import 'live_viewer_page.dart';

class WatchParty extends StatelessWidget {
  final List<Map<String, dynamic>> rooms = [
    {
      'id': 'marathi',
      'title': 'Marathi',
      'description': 'Fans of Marathi movies and dramas',
      'icon': Icons.movie_filter_outlined,
      'color': Color(0xFF1ED760), // Neon green
    },
    {
      'id': 'familytime',
      'title': 'Family Time',
      'description': 'Watch together with your family',
      'icon': Icons.family_restroom,
      'color': Color(0xFF1DB3E0), // Light cyan-blue
    },
    {
      'id': 'friends',
      'title': 'Friends',
      'description': 'Hang out virtually with your buddies',
      'icon': Icons.group_outlined,
      'color': Color(0xFF34D1BF), // Neon teal
    },
    {
      'id': 'malhar',
      'title': 'Malhar Fest',
      'description': '🎉 Watch college fest streamed live',
      'icon': Icons.celebration_outlined,
      'color': Color(0xFF007BFF), // Bright blue
    },
  ];

  void handleMalharTap(BuildContext context) {
    final directUrl = 'https://media.w3.org/2010/05/sintel/trailer.mp4';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LiveViewerPage(streamUrl: directUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1f1f1f),
      appBar: AppBar(
        title: const Text('🎬 Watch Party Rooms'),
        backgroundColor: const Color(0xFF2A2A2A),
        centerTitle: true,
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: GridView.builder(
          itemCount: rooms.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.90,
          ),
          itemBuilder: (context, index) {
            final room = rooms[index];

            return GestureDetector(
              onTap: () {
                if (room['id'] == 'malhar') {
                  handleMalharTap(context);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatRoom(roomId: room['id']),
                    ),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: room['color'],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: room['color'].withOpacity(0.6),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.15),
                      radius: 30,
                      child: Icon(
                        room['icon'],
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      room['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      room['description'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'chat_room.dart';
// import 'live_viewer_page.dart';

// class WatchParty extends StatelessWidget {
//   final List<Map<String, String>> rooms = [
//     {
//       'id': 'marathi',
//       'title': 'Marathi',
//       'description': 'Join fans of Marathi movies and dramas',
//       'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/Marathi_Cinema_logo.png/600px-Marathi_Cinema_logo.png'
//     },
//     {
//       'id': 'familytime',
//       'title': 'Family Time',
//       'description': 'Watch together, laugh together, family style',
//       'image': 'https://cdn-icons-png.flaticon.com/512/2922/2922510.png'
//     },
//     {
//       'id': 'friends',
//       'title': 'Friends',
//       'description': 'Hangout virtually and stream with friends',
//       'image': 'https://cdn-icons-png.flaticon.com/512/747/747968.png'
//     },
//     {
//       'id': 'malhar',
//       'title': 'Malhar Fest',
//       'description': '🎉 Watch college fest streamed live',
//       'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Malhar_logo.png/200px-Malhar_logo.png'
//     },
//   ];

//   void handleMalharTap(BuildContext context) {
//     final originalUrl = 'https://media.w3.org/2010/05/sintel/trailer.mp4';
//     final backendUrl = 'http://localhost:5000/convert?url=${Uri.encodeComponent(originalUrl)}';

//     // ✅ Navigate instantly, let LiveViewerPage handle loading and errors
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => LiveViewerPage(streamUrl: backendUrl),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1f1f1f),
//       appBar: AppBar(
//         title: const Text('Choose a Room'),
//         backgroundColor: Colors.black,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: GridView.builder(
//           itemCount: rooms.length,
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             childAspectRatio: 0.85,
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 10,
//           ),
//           itemBuilder: (context, index) {
//             final room = rooms[index];
//             return GestureDetector(
//               onTap: () {
//                 if (room['id'] == 'malhar') {
//                   handleMalharTap(context);
//                 } else {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => ChatRoom(roomId: room['id']!),
//                     ),
//                   );
//                 }
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF2b2b2b),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircleAvatar(
//                       radius: 35,
//                       backgroundImage: NetworkImage(room['image']!),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(room['title']!,
//                         style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white)),
//                     const SizedBox(height: 6),
//                     Text(room['description']!,
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(color: Colors.grey, fontSize: 12)),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

