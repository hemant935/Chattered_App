import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rtmp_broadcaster/camera.dart';
import 'package:go_router/go_router.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CameraPreviewWidget extends StatefulWidget {
  const CameraPreviewWidget({Key? key}) : super(key: key);

  @override
  _CameraPreviewWidgetState createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  late CameraController _controller;
  bool _isStreaming = false;
  bool _isInitialized = false;
  //late StreamSubscription<Map<String, dynamic>> _eventSubscription;

  @override
  void initState() {
    super.initState();
    _initializeFrontCamera();
  }

  Future<void> _startStreamingOnLoad() async {
    final url = 'rtmp://10.0.0.184/LiveApp/rY9HH21FsgaPJ9jc542341566086454';
    if (url != null) {
      print("START STREAMING");
      _startStreaming(url);
    }
  }

  Future<void> _initializeFrontCamera() async {
    try {
      // Fetch all available cameras
      final cameras = await availableCameras();

      // Find the front camera
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => throw Exception('No back camera found'), // Updated
      );

      // Initialize the camera controller with the front camera
      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: true,
      );

      await _controller.initialize();

      if (!mounted) return;

      setState(() {
        _isInitialized = true; // Mark the camera as initialized
      });
    } catch (e) {
      print('Error initializing front camera: $e');
    }
  }

  Future<void> _startStreaming(String url) async {
    try {
      await _controller.startVideoStreaming(url);
      setState(() {
        _isStreaming = true;
      });
    } catch (e) {
      print('Error starting stream: $e');
    }
  }

  Future<void> _stopStreaming() async {
    try {
      await _controller.stopVideoStreaming();
      setState(() {
        _isStreaming = false;
      });
      print('Streaming stopped');
    } catch (e) {
      print('Error stopping stream: $e');
    }
  }

  Future<String?> _getUrl(BuildContext context) async {
    // Prompt the user for an RTMP URL
    final TextEditingController _textFieldController = TextEditingController(
        text: "rtmp://10.0.0.184/LiveApp/rY9HH21FsgaPJ9jc542341566086454");
    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter RTMP URL'),
        content: TextField(
          controller: _textFieldController,
          decoration: InputDecoration(hintText: 'rtmp://your-stream-url'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final text = _textFieldController.text;
              Navigator.pop(context, text);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (_isInitialized) {
      // Check if initialized before disposing
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Wrap everything in a Scaffold
        body: SafeArea(
      child: Stack(
        children: [
          if (_isInitialized) // Only build preview when initialized
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: CameraPreview(_controller),
            )
          else
            Center(child: CircularProgressIndicator()),

          // Top UI elements (Live indicator, viewer count, etc.)

          if (_isStreaming)
            Positioned(
              top: 20,
              left: 10,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'Live',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 10),
                  // Icon(Icons.person, color: Colors.white),
                  // Text('247',
                  //     style: TextStyle(
                  //         color: Colors
                  //             .white)), // Replace with actual viewer count
                ],
              ),
            ),
          // Positioned(
          //   top: 20,
          //   right: 10,
          //   child: Container(
          //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          //     decoration: BoxDecoration(
          //       color: Colors.blue,
          //       borderRadius: BorderRadius.circular(5),
          //     ),
          //     child: Text(
          //       'Boost ends in 2:37',
          //       style: TextStyle(color: Colors.white),
          //     ),
          //   ),
          // ),

          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Padding(
              // Add padding to the entire button section
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0), // Add horizontal padding
              child: SizedBox(
                width: double
                    .infinity, // Make the SizedBox take up the entire width
                child: ElevatedButton(
                  onPressed: () async {
                    if (!_isStreaming) {
                      await _startStreamingOnLoad();
                    }

                    if (_isStreaming) {
                      await _stopStreaming();
                      if (context.mounted) {
                        context.go('/'); // Navigate back to the root route
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white
                        .withOpacity(0.15), // Semi-transparent background
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                        vertical: 15), // Reduce vertical padding if needed
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  child: Text(_isStreaming
                      ? 'End Live'
                      : 'Go Live'), // Conditional Text
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
