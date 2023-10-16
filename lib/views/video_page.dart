import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:webviewtube/webviewtube.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final controller = WebviewtubeController();
  final options = const WebviewtubeOptions(
      forceHd: true, loop: true, interfaceLanguage: 'id');

  @override
  void dispose() {
    // If a controller is passed to the player, remember to dispose it when
    // it's not in need.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        WebviewtubePlayer(
          videoId: YoutubePlayer.convertUrlToId('https://youtu.be/57MOJrjCev0')
              .toString(),
          options: options,
          controller: controller,
        ),
      ],
    );
  }
}
