import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:ui' as ui;
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';





class LiveViewerPage extends StatelessWidget {
  final String streamUrl;
  const LiveViewerPage({super.key, required this.streamUrl});

  bool _isIpCamStream(String url) {
    return url.contains("192.168.") ||
        url.contains("10.") ||
        url.contains("localhost") ||
        url.endsWith("/video") ||
        url.endsWith(".mjpg") ||
        url.endsWith(".mjpeg");
  }

  bool _isVideoStream(String url) {
    return url.endsWith('.mp4') ||
        url.endsWith('.m3u8') ||
        url.endsWith('.mpd') ||
        url.endsWith('.mov') ||
        url.endsWith('.webm') ||
        url.endsWith('.avi') ||
        url.contains(".ism/") ||
        url.endsWith(".ism");
  }

  @override
  Widget build(BuildContext context) {
    final isIpCam = _isIpCamStream(streamUrl);
    final isVideo = _isVideoStream(streamUrl);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF2C5364), Color(0xFF1CB5E0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple.shade700.withOpacity(0.9),
          elevation: 6,
          centerTitle: true,
          title: const Text(
            "Malhar Fest 2025",
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 1.2,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black38,
                  offset: Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double playerHeight = constraints.maxHeight * 0.38;
              return Column(
                children: [
                  // Full-width video player, no side padding
                  SizedBox(
                    height: playerHeight,
                    width: double.infinity,
                    child: isIpCam
                        ? MjpegStreamView(url: streamUrl)
                        : isVideo
                            ? VideoStreamPlayer(streamUrl: streamUrl)
                            : Container(
                                color: Colors.white,
                                child: const Center(
                                  child: Text(
                                    "⚠️ Unsupported stream type.",
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                  ),
                  // Button row with padding and spacing
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text('Play Stream'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.deepPurple,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.exit_to_app_rounded),
                            label: const Text("Exit Viewer"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Interaction panel
                 Expanded(
  flex: 3,
  child: InteractionSection(streamUrl: streamUrl),
),

                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class MjpegStreamView extends StatefulWidget {
  final String url;
  const MjpegStreamView({super.key, required this.url});

  @override
  State<MjpegStreamView> createState() => _MjpegStreamViewState();
}

class _MjpegStreamViewState extends State<MjpegStreamView> {
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(
        widget.url,
        (int viewId) => html.IFrameElement()
          ..src = widget.url
          ..style.border = 'none'
          ..width = '100%'
          ..height = '100%',
      );
    } else {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(widget.url));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return HtmlElementView(viewType: widget.url);
    } else if (_controller != null) {
      return WebViewWidget(controller: _controller!);
    } else {
      return const Center(
        child: Text(
          "WebView not supported on this platform",
          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
      );
    }
  }
}

class VideoStreamPlayer extends StatefulWidget {
  final String streamUrl;
  const VideoStreamPlayer({super.key, required this.streamUrl});

  @override
  State<VideoStreamPlayer> createState() => _VideoStreamPlayerState();
}

class _VideoStreamPlayerState extends State<VideoStreamPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      String url = widget.streamUrl.trim().toLowerCase();
      VideoFormat formatHint = VideoFormat.other;

      if (url.endsWith('.m3u8')) {
        formatHint = VideoFormat.hls;
      } else if (url.endsWith('.mpd')) {
        formatHint = VideoFormat.dash;
      } else if (url.contains(".ism/") || url.endsWith(".ism")) {
        formatHint = VideoFormat.ss;
      }

      _videoPlayerController = VideoPlayerController.network(
        widget.streamUrl,
        formatHint: formatHint,
      );

      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowPlaybackSpeedChanging: true,
        allowMuting: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.deepPurple,
          handleColor: Colors.amberAccent,
          backgroundColor: Colors.white70,
          bufferedColor: Colors.purpleAccent,
        ),
      );

      setState(() {
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.deepPurple,
          strokeWidth: 6,
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Text(
            "⚠️ Failed to load stream.\nPlease check your connection or try again later.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
      );
    }

    return Chewie(controller: _chewieController!);
  }
}
class InteractionSection extends StatefulWidget {
  final String streamUrl;

  const InteractionSection({super.key, required this.streamUrl});

  @override
  State<InteractionSection> createState() => _InteractionSectionState();
}

class _InteractionSectionState extends State<InteractionSection> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _commentController = TextEditingController();

  DateTime? _lastCommentTime;
  bool _showEmojiPicker = false;
  bool isLiked = false;
  String? _temporaryReaction;

  String get streamId => "stream_${widget.streamUrl.hashCode}";

  Future<void> _updateLikes(int likeCount) async {
    await _firestore.collection('streams').doc(streamId).set(
      {'likes': likeCount},
      SetOptions(merge: true),
    );
  }

  Future<void> _addReaction(String emoji) async {
    await _firestore.collection('streams').doc(streamId).set({
      'reactions': FieldValue.arrayUnion([emoji])
    }, SetOptions(merge: true));

    setState(() {
      _temporaryReaction = emoji;
    });

    // Hide emoji after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => _temporaryReaction = null);
    });
  }

  Future<void> _addComment(String text, String username, String? photoUrl) async {
    await _firestore.collection('streams').doc(streamId).set({
      'comments': FieldValue.arrayUnion([
        {
          'text': text,
          'username': username,
          'photoUrl': photoUrl,
          'timestamp': Timestamp.now(),
        }
      ])
    }, SetOptions(merge: true));
  }

  void _handleComment(User user) {
    final commentText = _commentController.text.trim();
    final now = DateTime.now();

    if (commentText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Comment cannot be empty")),
      );
      return;
    }

    if (_lastCommentTime != null && now.difference(_lastCommentTime!) < const Duration(seconds: 5)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please wait before posting again")),
      );
      return;
    }

    final rawName = user.displayName ?? user.email?.split('@')[0] ?? "Anonymous";
    final filteredName = rawName.replaceAll(RegExp(r'\d'), '');

    _addComment(
      commentText,
      filteredName.isEmpty ? "User" : filteredName,
      user.photoURL,
    );

    _commentController.clear();
    _lastCommentTime = now;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    return Stack(
      children: [
        StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection('streams').doc(streamId).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;
            int likeCount = data['likes'] ?? 0;
            List<String> reactions = List<String>.from(data['reactions'] ?? []);
            List<Map<String, dynamic>> comments =
                List<Map<String, dynamic>>.from(data['comments'] ?? []);

            return Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 12,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Likes and emoji toggle
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 4),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                            color: isLiked ? Colors.blue : Colors.grey.shade400,
                          ),
                          onPressed: () {
                            setState(() => isLiked = !isLiked);
                            _updateLikes(isLiked ? likeCount + 1 : likeCount - 1);
                          },
                        ),
                        Text(
                          '$likeCount Likes',
                          style: TextStyle(color: Colors.grey.shade300, fontSize: 15),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.amber),
                          onPressed: () {
                            setState(() => _showEmojiPicker = !_showEmojiPicker);
                          },
                        ),
                      ],
                    ),
                  ),

                  if (reactions.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 6),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 6.0,
                          runSpacing: 4.0,
                          children: reactions
                              .map((e) => Text(e, style: const TextStyle(fontSize: 22)))
                              .toList(),
                        ),
                      ),
                    ),

                  const Divider(color: Colors.white54, height: 18, thickness: 0.7),

                  // Comments Section
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: comments.isEmpty
                          ? Center(
                              child: Text(
                                "No comments yet. Be the first to comment!",
                                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.builder(
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                final c = comments[index];
                                final username = c['username'] ?? "User";
                                final text = c['text'] ?? "";
                                final String? photoUrl = c['photoUrl'];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.deepPurple.shade400,
                                        backgroundImage:
                                            photoUrl != null ? NetworkImage(photoUrl) : null,
                                        child: photoUrl == null
                                            ? Text(
                                                username.isNotEmpty ? username[0] : '?',
                                                style: const TextStyle(color: Colors.white),
                                              )
                                            : null,
                                        radius: 18,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.13),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                username,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                text,
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ),

                  // Comment Input
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Add a comment...",
                              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.deepPurpleAccent, width: 2),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            onSubmitted: (val) {
                              if (user != null) _handleComment(user);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (user != null) _handleComment(user);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          ),
                          child: const Text(
                            "Post",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Emoji Picker
                  if (_showEmojiPicker)
                    Container(
                      height: 250,
                      color: Colors.white, // Ensures emoji icons are visible
                      child: EmojiPicker(
                        onEmojiSelected: (category, emoji) {
                          _addReaction(emoji.emoji);
                          setState(() => _showEmojiPicker = false);
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        ),

        // Reaction overlay (disappears after 4 seconds)
        if (_temporaryReaction != null)
          Positioned(
            bottom: 100,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.85),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                _temporaryReaction!,
                style: const TextStyle(fontSize: 36),
              ),
            ),
          ),
      ],
    );
  }
}
