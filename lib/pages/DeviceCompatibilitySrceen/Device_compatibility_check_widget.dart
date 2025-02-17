import 'package:chattered_app/flutter_flow/nav/nav.dart';
import 'package:flutter/material.dart';

import 'custom_loading_indicator.dart';

class DeviceCompatibilityCheckScreen extends StatefulWidget {
  @override
  _DeviceCompatibilityCheckScreenState createState() =>
      _DeviceCompatibilityCheckScreenState();
}

class _DeviceCompatibilityCheckScreenState
    extends State<DeviceCompatibilityCheckScreen> {
  bool _isLoading = true; // Initially, the screen is in the loading state
  bool _networkStateEnabled = false; // State of Network Access

  @override
  void initState() {
    super.initState();
    _performDeviceCheck(); // Start the device check when the screen loads
  }

  // Simulate the device check process
  Future<void> _performDeviceCheck() async {
    // Simulate a delay for the device check
    await Future.delayed(const Duration(seconds: 3));

    // Simulate getting Network State Access
    setState(() {
      _networkStateEnabled = true;
    });

    // Simulate the completion of device check
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const SizedBox(height: 32),
                  _isLoading
                      ? CustomLoadingIndicator()
                      : _buildSuccessIndicator(),
                  const SizedBox(height: 60),
                  Text(
                    "We're conducting a device check to ensure your device is compatible",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: Column(
                      children: [
                        _buildChecklistItem(
                          "Signal Type: 5G Supported",
                          true, // Assume 5G is supported
                        ),
                        _buildChecklistItem(
                          "Current Signal Strength: Good",
                          true, // Assume signal strength is good
                        ),
                        _buildChecklistItem(
                          "Network State Access: Enabled",
                          _networkStateEnabled,
                        )
                      ],
                    ),
                  ),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        "Getting Network State Access...",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  if (!_isLoading)
                    Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        "Your Device is Boost compatible",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green[700],
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 80),
              Column(
                children: [
                  if (!_isLoading) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.push('/streamingPage');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Boost now for \$6"),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          context.push('/streamingPage');
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 16),
                          side: const BorderSide(color: Colors.blue),
                        ),
                        child: const Text("Boost after 7mins for \$5",
                            style: TextStyle(color: Colors.blue)),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text("Cancel"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for the loading indicator
  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 80,
      height: 80,
      child: CircularProgressIndicator(
        strokeWidth: 6,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
      ),
    );
  }

  // Widget for the success indicator (check mark icon)
  Widget _buildSuccessIndicator() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.check,
          size: 40,
          color: Colors.green[700],
        ),
      ),
    );
  }

  // Widget for the checklist item
  Widget _buildChecklistItem(String text, bool isChecked) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            isChecked
                ? Icons.check_circle_outline
                : Icons.radio_button_unchecked,
            color: isChecked ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
