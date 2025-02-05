import 'package:flutter/material.dart';
import 'package:rtmp_broadcaster/camera.dart';
import '../../custom_code/widgets/camera_preview_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class StreamingPageWidget extends StatefulWidget {
  const StreamingPageWidget({super.key});

  @override
  State<StreamingPageWidget> createState() => _StreamingPageWidgetState();
}

class _StreamingPageWidgetState extends State<StreamingPageWidget> {
  late List<CameraDescription> cameras;
  CameraDescription? selectedCamera;
  bool camerasLoaded = false;

  @override
  void initState() {
    super.initState();
    _fetchCameras();
  }

  Future<List<CameraDescription>> fetchCameras() async {
    try {
      return await availableCameras();
    } catch (e) {
      print('Error fetching cameras: $e');
      return [];
    }
  }

  Future<void> _fetchCameras() async {
    cameras = await fetchCameras();
    if (cameras.isNotEmpty) {
      setState(() {
        selectedCamera = cameras[0];
        camerasLoaded = true; // Set to true when cameras are loaded
      });
    }
  }

  void _onCameraSelected(CameraDescription camera) {
    setState(() {
      selectedCamera = camera;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: camerasLoaded
            ? SingleChildScrollView(
                // Only use SingleChildScrollView if cameras are loaded
                child: Column(
                  children: [
                    Material(
                      child: Container(),
                    ),

                    // Camera Preview Section
                    if (selectedCamera != null)
                      Material(
                        child: SizedBox(
                          height: MediaQuery.of(context)
                              .size
                              .height, // Occupy most of screen
                          child: const CameraPreviewWidget(),
                        ),
                      )
                    else
                      const Text('No cameras available'),
                  ],
                ),
              )
            : const Center(
                child:
                    CircularProgressIndicator()), // Show loading indicator initially
      ),
    );
  }
}
