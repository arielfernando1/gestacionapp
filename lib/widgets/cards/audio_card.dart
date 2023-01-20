import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../classes/post.dart';

// ignore: must_be_immutable
class AudioCard extends StatefulWidget {
  final Post post;
  //AlertDialog alertDialog;
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
          // onLongPress: () {
          //   showDialog(
          //     context: context,
          //     builder: (context) {
          //       return widget.alertDialog;
          //     },
          //   );
          // },
          onTap: () {
            // play audio on tap
          },
        ),
      ),
    );
  }
}
