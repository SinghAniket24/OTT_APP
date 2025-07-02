import 'package:flutter/material.dart';
import 'chat_room.dart';
import 'live_viewer_page.dart'; // import your live stream viewer

class WatchParty extends StatelessWidget {
  final List<Map<String, String>> rooms = [
    {
      'id': 'marathi',
      'title': 'Marathi',
      'description': 'Join fans of Marathi movies and dramas',
      'image':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/Marathi_Cinema_logo.png/600px-Marathi_Cinema_logo.png'
    },
    {
      'id': 'familytime',
      'title': 'Family Time',
      'description': 'Watch together, laugh together, family style',
      'image': 'https://cdn-icons-png.flaticon.com/512/2922/2922510.png'
    },
    {
      'id': 'friends',
      'title': 'Friends',
      'description': 'Hangout virtually and stream with friends',
      'image': 'https://cdn-icons-png.flaticon.com/512/747/747968.png'
    },
    {
      'id': 'malhar',
      'title': 'Malhar Fest',
      'description': '🎉 Watch college fest streamed live',
      'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Malhar_logo.png/200px-Malhar_logo.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1f1f1f),
      appBar: AppBar(
        title: const Text('Choose a Room'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: rooms.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final room = rooms[index];
            return GestureDetector(
              onTap: () {
                if (room['id'] == 'malhar') {
                  // 👇 IP camera viewer navigation
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LiveViewerPage(
                        streamUrl: 'https://media.w3.org/2010/05/sintel/trailer.mp4', // Change this to your actual stream URL
                      ),
                    ),
                  );
                } else {
                  // 👇 Normal chat room
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatRoom(roomId: room['id']!),
                    ),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2b2b2b),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(room['image']!),
                    ),
                    const SizedBox(height: 10),
                    Text(room['title']!,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 6),
                    Text(room['description']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
