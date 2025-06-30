// lib/screens/watchparty/watchparty.dart
import 'package:flutter/material.dart';
import 'chat_room.dart';

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
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1f1f1f),
      appBar: AppBar(
        title: Text('Choose a Room'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: rooms.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final room = rooms[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatRoom(roomId: room['id']!),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF2b2b2b),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(room['image']!),
                    ),
                    SizedBox(height: 10),
                    Text(room['title']!,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    SizedBox(height: 6),
                    Text(room['description']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
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
