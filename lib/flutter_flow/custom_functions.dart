import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';

String? newCustomFunction() {
  Future<void> startStreaming(CameraController controller, String url) async {
    try {
      await controller.startVideoStreaming(url);
      print('Streaming started to $url');
    } catch (e) {
      print('Error starting stream: $e');
    }
  }

  Future<void> stopStreaming(CameraController controller) async {
    try {
      await controller.stopVideoStreaming();
      print('Streaming stopped');
    } catch (e) {
      print('Error stopping stream: $e');
    }
  }
}
