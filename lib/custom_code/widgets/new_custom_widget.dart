// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!

import 'package:rtmp_broadcaster/rtmp_broadcaster.dart';

class RtmpBroadcastWidget extends StatefulWidget {
  @override
  _RtmpBroadcastWidgetState createState() => _RtmpBroadcastWidgetState();
}

class _RtmpBroadcastWidgetState extends State<RtmpBroadcastWidget> {
  late RtmpBroadcasterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RtmpBroadcasterController();
  }

  void _startBroadcast() async {
    await _controller.startBroadcast('rtmp://your-rtmp-server-url');
  }

  void _stopBroadcast() async {
    await _controller.stopBroadcast();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _startBroadcast,
          child: Text('Start Broadcast'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _stopBroadcast,
          child: Text('Stop Broadcast'),
        ),
      ],
    );
  }
}
