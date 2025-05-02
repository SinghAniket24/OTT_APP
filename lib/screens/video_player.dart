import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class MovieVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const MovieVideoPlayer({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<MovieVideoPlayer> createState() => _MovieVideoPlayerState();
}

class _MovieVideoPlayerState extends State<MovieVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  bool _isLoading = true;
  String? _errorMsg;
  String _selectedSubtitle = "English";
  final List<String> _subtitleOptions = ['English', 'Spanish', 'Off'];
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: false,
        looping: false,
        showControls: _showControls,
        allowFullScreen: true,
        allowMuting: true,
        allowPlaybackSpeedChanging: true,
        placeholder: Container(color: Colors.black),
      );

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _errorMsg = "Failed to load video: $e";
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

  void _showSubtitleMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: _subtitleOptions.map((option) {
            final bool isSelected = option == _selectedSubtitle;
            return ListTile(
              leading: isSelected ? const Icon(Icons.check, color: Colors.tealAccent) : null,
              title: Text(
                option,
                style: TextStyle(
                  color: isSelected ? Colors.tealAccent : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              onTap: () {
                setState(() => _selectedSubtitle = option);
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.tealAccent));
    }

    if (_errorMsg != null) {
      return Center(
        child: Text(_errorMsg!, style: const TextStyle(color: Colors.red)),
      );
    }

    return Stack(
      children: [
        AspectRatio(
          aspectRatio: _videoPlayerController.value.aspectRatio,
          child: Chewie(controller: _chewieController!),
        ),
        // Subtitle button placed at the top-left corner
        Positioned(
          top: 12,
          left: 12,
          child: GestureDetector(
            onTap: _showSubtitleMenu,
            child: Visibility(
              visible: _showControls, // Subtitle button hides with other controls
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.closed_caption, color: Colors.white, size: 26),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
