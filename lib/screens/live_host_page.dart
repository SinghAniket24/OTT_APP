import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'start_live.dart'; 

class LiveHostPage extends StatefulWidget {
  final String roomId;

  const LiveHostPage({super.key, required this.roomId});

  @override
  State<LiveHostPage> createState() => _LiveHostPageState();
}

class _LiveHostPageState extends State<LiveHostPage> with WidgetsBindingObserver {
  CameraController? _cameraController;
  bool _isCameraReady = false;
  bool _isMicOn = true;
  bool _isCameraOn = true;
  bool _isMirrored = false;
  List<CameraDescription> _cameras = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setupCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _setupCamera();
    }
  }

  Future<void> _setupCamera() async {
    final cameraStatus = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();

    if (!cameraStatus.isGranted || !micStatus.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera or Mic permission denied')),
      );
      return;
    }

    try {
      _cameras = await availableCameras();
      final frontCamera = _cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front);

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: true,
      );

      await _cameraController?.initialize();
      if (mounted) {
        setState(() {
          _isCameraReady = true;
        });
      }
    } catch (e) {
      print('Camera init failed: $e');
    }
  }

  void _toggleCamera() {
    setState(() {
      _isCameraOn = !_isCameraOn;
    });
  }

  void _toggleMic() {
    setState(() {
      _isMicOn = !_isMicOn;
    });
  }

  void _toggleMirror() {
    setState(() {
      _isMirrored = !_isMirrored;
    });
  }

  void _endStream() {
    _cameraController?.dispose();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const StartLivePage()),
      (route) => false,
    );
  }

  Widget _buildCameraPreview() {
    if (!_isCameraReady || _cameraController == null || !_isCameraOn) {
      return Container(
        color: Colors.black45,
        alignment: Alignment.center,
        child: const Text(
          "📵 Camera Off",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: _cameraController!.value.aspectRatio,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(_isMirrored ? 3.14 : 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CameraPreview(_cameraController!),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.grey.shade900,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(children: [
              const Icon(Icons.circle, color: Colors.red, size: 14),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  "Live: ${widget.roomId}",
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ]),
          ),
          Row(
            children: [
              Icon(_isCameraOn ? Icons.videocam : Icons.videocam_off, color: Colors.white),
              const SizedBox(width: 10),
              Icon(_isMicOn ? Icons.mic : Icons.mic_off, color: Colors.white),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildControls() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Controls", style: TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _buildControlButton(
                  icon: _isCameraOn ? Icons.videocam : Icons.videocam_off,
                  label: _isCameraOn ? "Video On" : "Video Off",
                  onTap: _toggleCamera,
                ),
                _buildControlButton(
                  icon: _isMicOn ? Icons.mic : Icons.mic_off,
                  label: _isMicOn ? "Mic On" : "Mic Off",
                  onTap: _toggleMic,
                ),
                _buildControlButton(
                  icon: Icons.flip_camera_android,
                  label: _isMirrored ? "Mirror On" : "Mirror Off",
                  onTap: _toggleMirror,
                ),
                _buildControlButton(
                  icon: Icons.stop_circle,
                  label: "End Stream",
                  color: Colors.red,
                  onTap: _endStream,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.grey,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildStatusBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: _buildCameraPreview(),
              ),
            ),
            _buildControls(),
          ],
        ),
      ),
    );
  }
}
