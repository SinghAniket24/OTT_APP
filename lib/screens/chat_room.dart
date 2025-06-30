import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'start_live.dart';
import 'live_lobby_page.dart';
import 'package:intl/intl.dart';

class ChatRoom extends StatefulWidget {
  final String roomId;
  const ChatRoom({super.key, required this.roomId});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  IO.Socket? socket;
  List<Map<String, dynamic>> messages = [];
  final TextEditingController controller = TextEditingController();
  List<Map<String, dynamic>> liveStreams = [];

  @override
  void initState() {
    super.initState();
    connectSocket();
  }

  void connectSocket() {
    socket = IO.io('http://localhost:5000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.connect();

    socket!.onConnect((_) {
      socket!.emit('joinRoom', {
        'roomId': widget.roomId,
        'email': 'user@example.com',
      });
    });

    socket!.on('receiveMessage', (msg) {
      setState(() {
        messages.add({
          'from': msg['from'],
          'text': msg['text'],
          'time': msg['timestamp'],
        });
      });
    });

    socket!.on('newLiveStarted', (data) {
      setState(() {
        liveStreams.add(data);
        messages.add({
          'from': 'System',
          'text': '${data['email']} just went live! Tap the 📺 icon to watch.',
          'time': DateTime.now().toIso8601String(),
        });
      });
    });

    socket!.on('liveEnded', (data) {
      setState(() {
        liveStreams.removeWhere((stream) => stream['roomId'] == data['roomId']);
        messages.add({
          'from': 'System',
          'text': '${data['email']} has ended their live stream.',
          'time': DateTime.now().toIso8601String(),
        });
      });
    });

    socket!.on('viewerUpdate', (data) {
      setState(() {
        final index = liveStreams.indexWhere((s) => s['roomId'] == data['roomId']);
        if (index != -1) {
          liveStreams[index]['viewers'] = data['viewers'];
        }
      });
    });

    socket!.onDisconnect((_) => print('🔌 Disconnected'));
  }

  void sendMessage(String msg) {
    if (msg.trim().isEmpty) return;
    socket?.emit('sendMessage', {
      'roomId': widget.roomId,
      'from': 'user@example.com',
      'text': msg,
    });

    setState(() {
      messages.add({
        'from': 'You',
        'text': msg,
        'time': DateTime.now().toIso8601String()
      });
      controller.clear();
    });
  }

  @override
  void dispose() {
    socket?.disconnect();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1F1C2C), Color(0xFF928DAB)],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, color: Colors.white),
                      const SizedBox(width: 8),
                      Text('#${widget.roomId}', style: const TextStyle(color: Colors.white, fontSize: 18)),
                    ],
                  ),
                  Row(
                    children: [
                      Tooltip(
                        message: "Start Live",
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const StartLivePage()),
                            );
                          },
                          icon: const Icon(Icons.videocam, color: Colors.red),
                          label: const Text("Go Live", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Tooltip(
                        message: "Watch Live",
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const LiveLobbyPage()),
                            );
                          },
                          icon: const Icon(Icons.live_tv, color: Colors.greenAccent),
                          label: const Text("Watch", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            if (liveStreams.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red.shade900, Colors.red.shade400],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🔴 Live Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...liveStreams.map((e) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const LiveLobbyPage()),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.play_circle_filled, color: Colors.white70),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${e['email']} is live – tap to watch (${e['viewers'] ?? 0} viewers)',
                                    style: const TextStyle(color: Colors.white70),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: messages.length,
                itemBuilder: (_, i) {
                  final msg = messages[i];
                  return Card(
                    color: msg['from'] == 'System'
                        ? Colors.purple.withOpacity(0.6)
                        : Colors.black.withOpacity(0.6),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(
                        msg['text'],
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        '${msg['from']} • ${DateFormat('hh:mm a').format(DateTime.parse(msg['time']))}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.black.withOpacity(0.4),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: const TextStyle(color: Colors.white54),
                        fillColor: Colors.grey.shade800,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onSubmitted: sendMessage,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Tooltip(
                    message: "Send Message",
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: () => sendMessage(controller.text),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
