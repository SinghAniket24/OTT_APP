// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
      // Detect format based on URL extension
      VideoFormat formatHint = VideoFormat.other;
      String videoUrl = widget.videoUrl.toLowerCase();

      // Check and convert Google Drive link
      final isGoogleDrive = videoUrl.contains("drive.google.com");
      if (isGoogleDrive && videoUrl.contains("/file/d/")) {
        final uriParts = videoUrl.split("/file/d/");
        if (uriParts.length > 1) {
          final fileId = uriParts[1].split("/").first;
          videoUrl = "https://drive.google.com/uc?export=download&id=$fileId";
        }
      }

      if (videoUrl.endsWith(".m3u8")) {
        formatHint = VideoFormat.hls;
      } else if (videoUrl.endsWith(".mpd")) {
        formatHint = VideoFormat.dash;
      } else if (videoUrl.endsWith(".ism") || videoUrl.contains(".ism/")) {
        formatHint = VideoFormat.ss;
      } else {
        formatHint = VideoFormat.other;
      }

      _videoPlayerController = VideoPlayerController.network(
        videoUrl,
        formatHint: formatHint,
      );

      await _videoPlayerController.initialize();

      final prefs = await SharedPreferences.getInstance();
      final lastPosition = prefs.getInt(widget.videoUrl) ?? 0;
      if (lastPosition > 0) {
        await _videoPlayerController.seekTo(Duration(seconds: lastPosition));
      }

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        showControls: _showControls,
        allowFullScreen: true,
        allowMuting: true,
        allowPlaybackSpeedChanging: true,
        placeholder: Container(color: Colors.black),
      );

      _videoPlayerController.addListener(() async {
        final prefs = await SharedPreferences.getInstance();
        final currentPosition = _videoPlayerController.value.position.inSeconds;
        await prefs.setInt(widget.videoUrl, currentPosition);
      });

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _errorMsg = "Failed to load video: $e";
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadVideo() async {
    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')),
        );
        return;
      }

      final dir = await getExternalStorageDirectory();
      final path = '${dir!.path}/downloaded_video.mp4';

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Downloading...')),
      );

      await Dio().download(
        widget.videoUrl,
        path,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            debugPrint("Downloading: ${(received / total * 100).toStringAsFixed(0)}%");
          }
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video saved at $path')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: $e')),
      );
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

        // Subtitle button
        Positioned(
          top: 12,
          left: 12,
          child: GestureDetector(
            onTap: _showSubtitleMenu,
            child: Visibility(
              visible: _showControls,
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

        // Download button
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: _downloadVideo,
            child: Visibility(
              visible: _showControls,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.download, color: Colors.white, size: 26),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
 