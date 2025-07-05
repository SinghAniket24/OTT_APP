import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

class LiveLobbyPage extends StatefulWidget {
  const LiveLobbyPage({super.key});

  @override
  State<LiveLobbyPage> createState() => _LiveLobbyPageState();
}

class _LiveLobbyPageState extends State<LiveLobbyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("🔴 Live Streams"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to StartLivePage or Go Live screen
            },
            icon: const Icon(Icons.add_circle_outline),
            tooltip: "Go Live",
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('live_sessions')
              .where('live', isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.red),
              );
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text("Failed to load streams",
                    style: TextStyle(color: Colors.white)),
              );
            }

            final liveStreams = snapshot.data?.docs ?? [];

            if (liveStreams.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.tv_off, size: 50, color: Colors.grey),
                    SizedBox(height: 10),
                    Text("No live streams available",
                        style: TextStyle(color: Colors.white70)),
                  ],
                ),
              );
            }

            return GridView.builder(
              itemCount: liveStreams.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, // 1 per row to show full video
                childAspectRatio: 16 / 9,
                mainAxisSpacing: 20,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final data =
                    liveStreams[index].data() as Map<String, dynamic>;
                final streamUrl = data['streamUrl'];
                final title = data['title'] ?? 'Untitled';
                final host = data['host'] ?? 'Host';

                return StreamCard(
                  title: title,
                  host: host,
                  streamUrl: streamUrl,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class StreamCard extends StatefulWidget {
  final String title;
  final String host;
  final String streamUrl;

  const StreamCard({
    super.key,
    required this.title,
    required this.host,
    required this.streamUrl,
  });

  @override
  State<StreamCard> createState() => _StreamCardState();
}

class _StreamCardState extends State<StreamCard> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.streamUrl)
      ..initialize().then((_) {
        setState(() => _isInitialized = true);
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : const Center(
                  child: CircularProgressIndicator(color: Colors.red),
                ),
          const SizedBox(height: 8),
          Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "Host: ${widget.host}",
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Icon(Icons.circle, size: 10, color: Colors.red),
              SizedBox(width: 4),
              Text("Live now",
                  style: TextStyle(color: Colors.white60, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
