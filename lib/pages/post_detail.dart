// ignore_for_file: implementation_imports, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_test/firebase_controllers/firestore_controller.dart';
import 'package:firebase_test/pages/home_page.dart';
import 'package:firebase_test/pages/player_page.dart';
import 'package:flutter/material.dart';
import '../classes/post.dart';

// ignore: must_be_immutable
class PostDetail extends StatefulWidget {
  Firestore firestore = Firestore();
  Post post;
  PostDetail({super.key, required this.post});

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  @override
  void initState() {
    super.initState();
    log('PostDetail: initState()');
  }

  @override
  Widget build(BuildContext context) {
    // return post image from post.file base64
    return widget.post.postType == 1
        ? postPhoto()
        : widget.post.postType == 2
            ? AudioDetail(post: widget.post)
            : Container();
  }

  Widget postPhoto() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Detalles del recuerdo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/edit_post',
                  arguments: widget.post);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              log('No hago nada');
              // delete post
              // widget.firestore.destroyPost(widget.post.id).then((value) =>
              //     Navigator.pushReplacement(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => const HomePage())));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(50)),
              child: Image.memory(
                base64Decode(widget.post.file),
                fit: BoxFit.scaleDown,
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              widget.post.title,
              style: Theme.of(context).textTheme.headline1,
            ),
            const SizedBox(height: 24.0),
            Text(
              '"${widget.post.description}"',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      // image filter selector
    );
  }

  // Widget postAudio() {
  //   // return audioplayers player
  //   return Scaffold(
  //     appBar: AppBar(
  //       centerTitle: true,
  //       title: const Text('Detalles del post'),
  //       actions: [
  //         IconButton(
  //           icon: const Icon(Icons.edit),
  //           onPressed: () {},
  //         ),
  //         IconButton(
  //           icon: const Icon(Icons.delete),
  //           onPressed: () {},
  //         ),
  //       ],
  //     ),
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               CircleAvatar(
  //                 radius: 25,
  //                 child: IconButton(
  //                   icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
  //                   onPressed: () {
  //                     if (isPlaying) {
  //                       player.pause();
  //                     } else {
  //                       final bytes = base64Decode(widget.post.file);
  //                       player.play(BytesSource(bytes));
  //                     }
  //                   },
  //                 ),
  //               ),
  //               const SizedBox(width: 20.0, height: 20),
  //               CircleAvatar(
  //                 radius: 25,
  //                 child: IconButton(
  //                   icon: const Icon(Icons.stop),
  //                   onPressed: () {
  //                     player.stop();
  //                   },
  //                 ),
  //               )
  //             ],
  //           ),
  //           // ElevatedButton(
  //           //     onPressed: (() {
  //           //       final bytes = base64Decode(widget.post.file);
  //           //       player.play(BytesSource(bytes));
  //           //     }),
  //           //     child: const Text('Play audio')),
  //           // ElevatedButton(
  //           //     onPressed: (() {
  //           //       player.stop();
  //           //     }),
  //           //     child: const Text('Stop')),
  //           // ElevatedButton(onPressed: () {}, child: const Text('Pause')),
  //           Slider(
  //             min: 0,
  //             max: duration.inSeconds.toDouble(),
  //             value: position.inSeconds.toDouble(),
  //             onChanged: (value) {
  //               final position = Duration(seconds: value.toInt());
  //               player.seek(position);
  //               player.resume();
  //             },
  //           ),
  //           Container(
  //             padding: const EdgeInsets.all(20),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(formatTime(position.inSeconds)),
  //                 Text(formatTime((duration - position).inSeconds))
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
