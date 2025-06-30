// import 'package:flutter/material.dart';
// import 'chat_room.dart';

// class JoinRoomScreen extends StatelessWidget {
//   final List<Map<String, String>> rooms = [
//     {
//       'id': 'marathi',
//       'title': 'Marathi',
//       'description': 'Join fans of Marathi movies and dramas',
//       'image':
//           'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/Marathi_Cinema_logo.png/600px-Marathi_Cinema_logo.png',
//     },
//     {
//       'id': 'familytime',
//       'title': 'Family Time',
//       'description': 'Watch together, laugh together, family style',
//       'image': 'https://cdn-icons-png.flaticon.com/512/2922/2922510.png',
//     },
//     {
//       'id': 'friends',
//       'title': 'Friends',
//       'description': 'Hangout virtually and stream with friends',
//       'image': 'https://cdn-icons-png.flaticon.com/512/747/747968.png',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF1F1F1F),
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Text("Choose a Room"),
//       ),
//       body: GridView.builder(
//         padding: EdgeInsets.all(16),
//         itemCount: rooms.length,
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           childAspectRatio: 0.85,
//           crossAxisSpacing: 16,
//           mainAxisSpacing: 16,
//         ),
//         itemBuilder: (context, index) {
//           final room = rooms[index];
//           return GestureDetector(
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(
//                 builder: (_) => ChatRoomScreen(roomId: room['id']!),
//               ));
//             },
//             child: Container(
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Color(0xFF2B2B2B),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircleAvatar(
//                     backgroundImage: NetworkImage(room['image']!),
//                     radius: 36,
//                   ),
//                   SizedBox(height: 12),
//                   Text(
//                     room['title']!,
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//                   ),
//                   SizedBox(height: 6),
//                   Text(
//                     room['description']!,
//                     style: TextStyle(fontSize: 12, color: Colors.grey[400]),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
