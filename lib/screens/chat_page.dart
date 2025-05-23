// import 'package:flutter/material.dart';
// import 'package:agora_rtm/agora_rtm.dart';

// class ChatPage extends StatefulWidget {
//   final String userId; // Pass a unique userId like 'user123'
//   final String channelName; // e.g., 'group1'

//   const ChatPage({
//     Key? key,
//     required this.userId,
//     required this.channelName,
//   }) : super(key: key);

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   static const String appId = 'YOUR_AGORA_APP_ID'; // <-- Replace this

//   late AgoraRtmClient _client;
//   AgoraRtmChannel? _channel;
//   List<String> _messages = [];
//   final TextEditingController _controller = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _initRTM();
//   }

//   Future<void> _initRTM() async {
//     _client = await AgoraRtmClient.createInstance(appId);

//     _client.onMessageReceived = (AgoraRtmMessage msg, String peerId) {
//       print("Direct msg from $peerId: ${msg.text}");
//     };

//     _client.onConnectionStateChanged = (int state, int reason) {
//       print('Connection state changed: $state');
//       if (state == 5) {
//         _client.logout();
//         print('Logged out.');
//       }
//     };

//     await _client.login(null, widget.userId);

//     _channel = await _client.createChannel(widget.channelName);
//     _channel?.onMessageReceived = (AgoraRtmMessage message, AgoraRtmMember member) {
//       setState(() {
//         _messages.add("${member.userId}: ${message.text}");
//       });
//     };

//     await _channel?.join();
//   }

//   Future<void> _sendMessage(String text) async {
//     if (text.isEmpty) return;
//     try {
//       await _channel?.sendMessage(AgoraRtmMessage.fromText(text));
//       setState(() {
//         _messages.add("Me: $text");
//         _controller.clear();
//       });
//     } catch (e) {
//       print('Send message error: $e');
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _channel?.leave();
//     _channel?.destroy();
//     _client.logout();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Group: ${widget.channelName}'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: _messages.length,
//               padding: const EdgeInsets.all(8),
//               itemBuilder: (context, index) {
//                 return Align(
//                   alignment: _messages[index].startsWith("Me:") ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     decoration: BoxDecoration(
//                       color: _messages[index].startsWith("Me:")
//                           ? Colors.teal.withOpacity(0.7)
//                           : Colors.grey[700],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Text(
//                       _messages[index],
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           const Divider(height: 1),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     onSubmitted: _sendMessage,
//                     decoration: const InputDecoration(
//                       hintText: 'Type your message...',
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: () => _sendMessage(_controller.text),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
