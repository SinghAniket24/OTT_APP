import 'package:flutter/material.dart';

class LiveLobbyPage extends StatefulWidget {
  const LiveLobbyPage({super.key});

  @override
  State<LiveLobbyPage> createState() => _LiveLobbyPageState();
}

class _LiveLobbyPageState extends State<LiveLobbyPage> {
  bool loading = true;
  String? error;
  List<Map<String, dynamic>> streams = [];

  @override
  void initState() {
    super.initState();
    fetchStreams();
  }

  Future<void> fetchStreams() async {
    try {
      // Replace with your actual backend URL
      final response = await Uri.parse("http://localhost:5000/live-streams");
      // Simulated placeholder logic for now
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        streams = [
          {
            "roomId": "abc123",
            "title": "Chai with Aniket",
            "email": "aniket@example.com",
            "startedAt": DateTime.now().toString(),
            "viewers": 12
          },
          {
            "roomId": "xyz789",
            "title": "Flutter Tips Live",
            "email": "dev@example.com",
            "startedAt": DateTime.now().toString(),
            "viewers": 7
          },
        ];
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = "Failed to load streams";
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.red),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 40),
              const SizedBox(height: 12),
              Text(error!, style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: fetchStreams,
                child: const Text("Retry"),
              )
            ],
          ),
        ),
      );
    }

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
        child: streams.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.tv_off, size: 50, color: Colors.grey),
                    SizedBox(height: 10),
                    Text("No live streams available",
                        style: TextStyle(color: Colors.white70))
                  ],
                ),
              )
            : GridView.builder(
                itemCount: streams.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 16 / 10,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final stream = streams[index];
                  return InkWell(
                    onTap: () {
                      // Navigate to view page using stream['roomId']
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade900,
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Center(
                              child: Icon(Icons.videocam, size: 40, color: Colors.red),
                            ),
                          ),
                          Text(
                            stream["title"] ?? "Untitled",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            stream["email"] ?? "",
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.circle, size: 10, color: Colors.red),
                              Text(" ${stream['viewers']} watching",
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white60)),
                            ],
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
