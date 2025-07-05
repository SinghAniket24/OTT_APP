import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uuid/uuid.dart';
import 'live_host_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class StartLivePage extends StatefulWidget {
  const StartLivePage({super.key});

  @override
  State<StartLivePage> createState() => _StartLivePageState();
}

class _StartLivePageState extends State<StartLivePage> {
  String status = "initializing";
  String? error;
  final String roomId = const Uuid().v4();
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    initializeStream();
  }

  Future<void> initializeStream() async {
    try {
      setState(() => status = "checking_permissions");

      var cameraStatus = await Permission.camera.request();
      var micStatus = await Permission.microphone.request();

      if (!cameraStatus.isGranted || !micStatus.isGranted) {
        throw Exception("Camera or Microphone permission denied");
      }

      setState(() => status = "connecting_server");

      socket = IO.io('http://localhost:5000', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
      socket.connect();

socket.onConnect((_) async {
  setState(() => status = "creating_room");

  // Emit socket event to create the live room on server
  socket.emit('startLive', {
    'email': 'user@example.com',
    'title': 'My Live Stream',
    'roomId': roomId,
  });

  // Get the current Firebase user
  final user = FirebaseAuth.instance.currentUser;

  // ✅ Send notification to chat room
  if (user != null) {
    await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .add({
          'sender': user.displayName ?? user.email ?? 'Host',
          'text': '🔴 Live has started! Join now.',
          'type': 'notification',
          'timestamp': FieldValue.serverTimestamp(),
        });

    // ✅ Save live session details for viewers
    await FirebaseFirestore.instance
        .collection('live_sessions')
        .doc(roomId)
        .set({
          'roomId': roomId,
          'title': 'My Live Stream',
          'host': user.displayName ?? user.email ?? 'Host',
          'live': true,
          'startedAt': FieldValue.serverTimestamp(),
        });
  }

  // Navigate to the host page
  Future.delayed(const Duration(seconds: 1), () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveHostPage(roomId: roomId),
      ),
    );
  });
});


      socket.onConnectError((_) {
        throw Exception("Connection failed");
      });

    } catch (e) {
      setState(() {
        error = e.toString();
        status = "failed";
      });
    }
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  Widget buildStatus() {
    if (error != null) {
      return Column(
        children: [
          Text("❌ $error", style: const TextStyle(color: Colors.red)),
          ElevatedButton(onPressed: () => initializeStream(), child: const Text("Retry")),
        ],
      );
    }

    final statusText = {
      "initializing": "Initializing...",
      "checking_permissions": "Checking camera/mic access...",
      "connecting_server": "Connecting to server...",
      "creating_room": "Creating stream room...",
      "failed": "Failed",
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 20),
        Text(statusText[status] ?? status),
        const SizedBox(height: 10),
        if (status != "failed") Text("Room ID: $roomId"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: buildStatus()),
    );
  }
}
