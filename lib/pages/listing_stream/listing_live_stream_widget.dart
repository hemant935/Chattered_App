import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

class LiveStreamsListingPage extends StatefulWidget {
  const LiveStreamsListingPage({Key? key}) : super(key: key);

  @override
  _LiveStreamsListingPageState createState() => _LiveStreamsListingPageState();
}

class _LiveStreamsListingPageState extends State<LiveStreamsListingPage> {
  List<dynamic> _liveStreams = [];

  @override
  void initState() {
    super.initState();
    _loadLiveStreams();
  }

  Future<void> _loadLiveStreams() async {
    final jsonString = await rootBundle.loadString('assets/live_streams.json');
    final jsonData = jsonDecode(jsonString);

    setState(() {
      _liveStreams = jsonData['streams'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      "Shardia",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 8.0),
                  child: Text(
                    "Available streams (${_liveStreams.length})",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _liveStreams.length,
                  itemBuilder: (context, index) {
                    final stream = _liveStreams[index];
                    return LiveStreamItem(
                      streamId: stream['streamId'],
                      name: stream['name'],
                      description: stream['description'],
                      thumbnail: stream['thumbnail'],
                      rtmpUrl: stream['rtmpUrl'],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/createStream');
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fiber_manual_record),
            label: 'Record',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            label: 'Help',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }
}

class LiveStreamItem extends StatelessWidget {
  final String streamId;
  final String name;
  final String description;
  final String thumbnail;
  final String rtmpUrl;

  const LiveStreamItem({
    Key? key,
    required this.streamId,
    required this.name,
    required this.description,
    required this.thumbnail,
    required this.rtmpUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final liveStreamUrl =
        'http://10.0.0.184:5080/LiveApp/play.html?id=$streamId';

    return GestureDetector(
      onTap: () {
        // Navigate to the stream view page with the constructed RTMP URL
        context.goNamed('live_view',
            queryParameters: {'liveStreamUrl': liveStreamUrl});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CachedNetworkImage(
                      imageUrl: thumbnail,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "LIVE",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 20.0),
              child: Text(
                description, // Show the description now
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
