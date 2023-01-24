import 'dart:convert';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../classes/post.dart';

class AudioDetail extends StatefulWidget {
  final Post post;
  const AudioDetail({super.key, required this.post});

  @override
  State<AudioDetail> createState() => _AudioDetailState();
}

class _AudioDetailState extends State<AudioDetail> {
  final player = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  }

  @override
  void initState() {
    super.initState();
    log('PostDetail: initState()');
    player.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    player.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    player.onPositionChanged.listen((newPosition) {
      position = newPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bytes = base64Decode(widget.post.file);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Reproducir Audio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: const Color.fromRGBO(205, 180, 219, 1),
                  radius: 32,
                  child: IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                    onPressed: () {
                      if (isPlaying) {
                        player.pause();
                      } else {
                        player.play(BytesSource(bytes));
                      }
                    },
                  ),
                ),
                const SizedBox(width: 20.0, height: 20),
                CircleAvatar(
                  backgroundColor: const Color.fromRGBO(205, 180, 219, 1),
                  radius: 32,
                  child: IconButton(
                    icon: const Icon(Icons.stop),
                    onPressed: () {
                      player.stop();
                    },
                  ),
                )
              ],
            ),
            // ElevatedButton(
            //     onPressed: (() {
            //       final bytes = base64Decode(widget.post.file);
            //       player.play(BytesSource(bytes));
            //     }),
            //     child: const Text('Play audio')),
            // ElevatedButton(
            //     onPressed: (() {
            //       player.stop();
            //     }),
            //     child: const Text('Stop')),
            // ElevatedButton(onPressed: () {}, child: const Text('Pause')),
            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value) {
                final position = Duration(seconds: value.toInt());
                player.seek(position);
                player.resume();
              },
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatTime(position.inSeconds)),
                  Text(formatTime((duration - position).inSeconds))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
