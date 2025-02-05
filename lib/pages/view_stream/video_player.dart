import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LiveStreamVideoPlayer extends StatefulWidget {
  final String liveStreamUrl;

  const LiveStreamVideoPlayer({super.key, required this.liveStreamUrl});

  @override
  State<LiveStreamVideoPlayer> createState() => _LiveStreamWebViewState();
}

class _LiveStreamWebViewState extends State<LiveStreamVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isError = false;

  @override
  void initState() {
    super.initState();

    // Initialize the video player controller with the HLS stream URL
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.liveStreamUrl))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
      }).catchError((error) {
        // Handle errors during video initialization
        setState(() {
          _isError = true;
        });
        print('Error initializing HLS stream: $error');
      });
  }

  @override
  void dispose() {
    // Dispose of the video player controller when the widget is removed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HLS Stream Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('HLS Live Stream'),
        ),
        body: Center(
          child: _isError
              ? Text(
                  'Failed to load HLS stream. Please check the URL.',
                  style: TextStyle(color: Colors.red),
                )
              : _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : CircularProgressIndicator(), // Show loading indicator while initializing
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }
}