import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../service/service_api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: VideoPage(),
    );
  }
}

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    super.initState();
    _youtubeController = YoutubePlayerController(
      initialVideoId:
          YoutubePlayer.convertUrlToId('https://youtu.be/57MOJrjCev0')
              .toString(),
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    );
  }

  @override
  void dispose() {
    _youtubeController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: GestureDetector(
                onDoubleTap: () {
                  openFullScreenVideo(context);
                },
                onHorizontalDragStart: (details) {
                  final currentPosition = _youtubeController!.value.position;
                  final backwardPosition = Duration(
                    seconds: currentPosition.inSeconds - 1,
                  );

                  // Seek backward by 10 seconds when double-tap down
                  _youtubeController!.seekTo(backwardPosition);
                },
                child: YoutubePlayer(
                  controller: _youtubeController!,
                  showVideoProgressIndicator: true,
                  onEnded: (metadata) {
                    // Handle video end
                  },
                  bottomActions: [
                    CurrentPosition(),
                    const SizedBox(width: 10.0),
                    ProgressBar(isExpanded: true),
                    const SizedBox(width: 10.0),
                    RemainingDuration(),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        openFullScreenVideo(context);
                      },
                      child: const Icon(
                        Icons.fullscreen,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ),
            FutureBuilder<Map<String, dynamic>>(
              future: fetchYouTubeVideoInfo('https://youtu.be/57MOJrjCev0'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      enabled: true,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 10, bottom: 10),
                                    height: 16,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    height: 12,
                                    width: 120,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final videoInfo = snapshot.data;
                  return Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          videoInfo!['title'],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          videoInfo['author_name'],
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                          maxLines: 3,
                        ),
                        // Add more information as needed
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void openFullScreenVideo(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    _youtubeController!.pause();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPage(_youtubeController!),
      ),
    ).then((value) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    });
  }
}

class FullScreenVideoPage extends StatefulWidget {
  final YoutubePlayerController controller;

  FullScreenVideoPage(this.controller);

  @override
  State<FullScreenVideoPage> createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {
  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    _youtubeController = YoutubePlayerController(
      initialVideoId:
          YoutubePlayer.convertUrlToId('https://youtu.be/57MOJrjCev0')
              .toString(),
      flags: const YoutubePlayerFlags(autoPlay: false),
    );
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: [SystemUiOverlay.top]);
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          return true;
        },
        child: Center(
          child: GestureDetector(
            onDoubleTap: () {
              final currentPosition = _youtubeController.value.position;
              final forwardPosition = Duration(
                seconds: currentPosition.inSeconds + 10,
              );

              // Seek forward by 10 seconds when double-tapped
              _youtubeController.seekTo(forwardPosition);
            },
            onHorizontalDragStart: (details) {
              final currentPosition = _youtubeController.value.position;
              final backwardPosition = Duration(
                seconds: currentPosition.inSeconds - 1,
              );

              // Seek backward by 10 seconds when double-tap down
              _youtubeController.seekTo(backwardPosition);
            },
            child: YoutubePlayer(
              controller: _youtubeController,
              showVideoProgressIndicator: true,
              onEnded: (metadata) {
                // Handle video end
              },
              bottomActions: [
                CurrentPosition(),
                const SizedBox(width: 10.0),
                ProgressBar(isExpanded: true),
                const SizedBox(width: 10.0),
                RemainingDuration(),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                        overlays: [SystemUiOverlay.top]);
                    SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.portraitUp]);
                    Navigator.pop(context, _youtubeController);
                  },
                  child: const Icon(
                    Icons.fullscreen_exit,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
