// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:permission_handler/permission_handler.dart';

// // Join Room Page
// class JoinRoomPage extends StatefulWidget {
//   @override
//   _JoinRoomPageState createState() => _JoinRoomPageState();
// }

// class _JoinRoomPageState extends State<JoinRoomPage> {
//   final TextEditingController _roomIdController = TextEditingController();
//   final Signaling _signaling = Signaling();

//   @override
//   void initState() {
//     super.initState();
//     _signaling.connect();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Join Room')),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _roomIdController,
//               decoration: const InputDecoration(
//                 labelText: 'Room ID',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 final roomId = _roomIdController.text.trim();
//                 if (roomId.isNotEmpty) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => VideoCallPage(
//                         roomId: roomId,
//                         signaling: _signaling,
//                         isCaller: true,
//                       ),
//                     ),
//                   );
//                 }
//               },
//               child: const Text('Join Room'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Video Call Page
// class VideoCallPage extends StatefulWidget {
//   final String roomId;
//   final Signaling signaling;
//   final bool isCaller;

//   VideoCallPage({
//     required this.roomId,
//     required this.signaling,
//     required this.isCaller,
//   });

//   @override
//   _VideoCallPageState createState() => _VideoCallPageState();
// }

// class _VideoCallPageState extends State<VideoCallPage> {
//   final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
//   final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
//   MediaStream? _localStream;
//   RTCPeerConnection? _peerConnection;
//   bool _isMuted = false;
//   bool _isVideoOff = false;

//   @override
//   void initState() {
//     super.initState();
//     _initWebRTC();
//   }

//   Future<void> _initWebRTC() async {
//     await [Permission.camera, Permission.microphone].request();
//     await _initializeRenderers();

//     final mediaConstraints = <String, dynamic>{
//       'audio': true,
//       'video': {'mandatory': {}, 'optional': []}
//     };

//     _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
//     _localRenderer.srcObject = _localStream;

//     _peerConnection = await createPeerConnection({
//       'iceServers': [{'urls': 'stun:stun.l.google.com:19302'}]
//     });

//     _setupPeerConnection();
//     _setupSignalingHandlers();

//     if (widget.isCaller) {
//       _createAndSendOffer();
//     } else {
//       _listenForOffer();
//     }
//   }

//   Future<void> _initializeRenderers() async {
//     await _localRenderer.initialize();
//     await _remoteRenderer.initialize();
//   }

//   void _setupPeerConnection() {
//     _localStream!.getTracks().forEach((track) {
//       _peerConnection!.addTrack(track, _localStream!);
//     });

//     _peerConnection!.onIceCandidate = (candidate) {
//       if (candidate != null) {
//         widget.signaling.sendIceCandidate(
//           widget.roomId,
//           candidate.toMap(),
//         );
//       }
//     };

//     _peerConnection!.onTrack = (event) {
//       if (event.streams.isNotEmpty) {
//         _remoteRenderer.srcObject = event.streams.first;
//       }
//     };
//   }

//   void _setupSignalingHandlers() {
//     widget.signaling.onRemoteAnswer = (answer) async {
//       await _peerConnection!.setRemoteDescription(
//         RTCSessionDescription(answer['sdp'], answer['type']),
//       );
//     };

//     widget.signaling.onIceCandidateReceived = (candidate) {
//       _peerConnection!.addIceCandidate(
//         RTCIceCandidate(
//           candidate['candidate'],
//           candidate['sdpMid'],
//           candidate['sdpMLineIndex'],
//         ),
//       );
//     };

//     widget.signaling.onOfferReceived = (offer) async {
//       if (!widget.isCaller) {
//         await _handleReceivedOffer(offer);
//       }
//     };
//   }

//   Future<void> _createAndSendOffer() async {
//     final offer = await _peerConnection!.createOffer();
//     await _peerConnection!.setLocalDescription(offer);
//     widget.signaling.sendOffer(widget.roomId, offer.toMap());
//   }

//   Future<void> _listenForOffer() async {
//     widget.signaling.onOfferReceived = (offer) async {
//       await _peerConnection!.setRemoteDescription(
//         RTCSessionDescription(offer['sdp'], offer['type']),
//       );
//       final answer = await _peerConnection!.createAnswer();
//       await _peerConnection!.setLocalDescription(answer);
//       widget.signaling.sendAnswer(widget.roomId, answer.toMap());
//     };
//   }

//   Future<void> _handleReceivedOffer(dynamic offer) async {
//     await _peerConnection!.setRemoteDescription(
//       RTCSessionDescription(offer['sdp'], offer['type']),
//     );
//     final answer = await _peerConnection!.createAnswer();
//     await _peerConnection!.setLocalDescription(answer);
//     widget.signaling.sendAnswer(widget.roomId, answer.toMap());
//   }

//   void _toggleMute() {
//     setState(() {
//       _isMuted = !_isMuted;
//     });
//     _localStream?.getAudioTracks().forEach((track) {
//       track.enabled = !_isMuted;
//     });
//   }

//   void _toggleVideo() {
//     setState(() {
//       _isVideoOff = !_isVideoOff;
//     });
//     _localStream?.getVideoTracks().forEach((track) {
//       track.enabled = !_isVideoOff;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Room ${widget.roomId}')),
//       body: Column(
//         children: [
//           Expanded(
//             child: RTCVideoView(_remoteRenderer),
//           ),
//           Expanded(
//             child: RTCVideoView(_localRenderer),
//           ),
//           _buildControlBar(),
//         ],
//       ),
//     );
//   }

//   Widget _buildControlBar() {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 20),
//       color: Colors.black26,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           IconButton(
//             icon: Icon(_isMuted ? Icons.mic_off : Icons.mic),
//             color: Colors.white,
//             onPressed: _toggleMute,
//           ),
//           IconButton(
//             icon: Icon(_isVideoOff ? Icons.videocam_off : Icons.videocam),
//             color: Colors.white,
//             onPressed: _toggleVideo,
//           ),
//           IconButton(
//             icon: Icon(Icons.call_end),
//             color: Colors.red,
//             onPressed: () => Navigator.pop(context),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _localRenderer.dispose();
//     _remoteRenderer.dispose();
//     _peerConnection?.close();
//     _localStream?.dispose();
//     widget.signaling.disconnect();
//     super.dispose();
//   }
// }

// // Signaling Class
// class Signaling {
//   final Map<String, Function(dynamic)> _offerHandlers = {};
//   final Map<String, Function(dynamic)> _answerHandlers = {};
//   final Map<String, Function(dynamic)> _iceCandidateHandlers = {};

//   Function(dynamic)? onRemoteAnswer;
//   Function(dynamic)? onIceCandidateReceived;
//   Function(dynamic)? onOfferReceived;

//   Future<void> connect() async {
//     // Implement WebSocket connection
//   }

//   void disconnect() {
//     // Implement WebSocket disconnection
//   }

//   void sendOffer(String roomId, dynamic offer) {
//     // Send offer via signaling server
//   }

//   void sendAnswer(String roomId, dynamic answer) {
//     // Send answer via signaling server
//   }

//   void sendIceCandidate(String roomId, dynamic candidate) {
//     // Send ICE candidate via signaling server
//   }
// }
