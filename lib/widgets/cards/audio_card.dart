import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../classes/post.dart';
import '../../firebase_controllers/firestore_controller.dart';

class AudioCard extends StatefulWidget {
  final Post post;
  const AudioCard({super.key, required this.post});

  @override
  State<AudioCard> createState() => _AudioCardState();
}

class _AudioCardState extends State<AudioCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade100,
      margin: const EdgeInsets.all(5.0),
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.music_note, color: Colors.black, size: 40),
          title: Text(widget.post.title),
          subtitle: Text(widget.post.description.toString()),
          trailing: Text(timeago.format(widget.post.date)),
          onLongPress: () {
            // play audio
            // ignore: avoid_print
            print('play audio');
          },
        ),
      ),
    );
  }
}
