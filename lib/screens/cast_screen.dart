import 'package:flutter/material.dart';

class CastScreen extends StatelessWidget {
  const CastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cast to TV'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cast_connected, size: 100, color: Colors.deepOrange),
            const SizedBox(height: 20),
            const Text(
              'Searching for available devices...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please wait or connect manually.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
