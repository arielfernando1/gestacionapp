import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../classes/post.dart';
import '../../pages/post_detail.dart';

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
    // string to uint8list
    return Container(
      margin: const EdgeInsets.all(5.0),
      // ignore: prefer_const_constructors
      decoration: BoxDecoration(
        boxShadow: const [
          // ignore: prefer_const_constructors
          BoxShadow(
              color: Color.fromRGBO(255, 175, 204, 1),
              blurRadius: 15,
              offset: Offset(4, 4))
        ],
      ),
      child: Card(
        child: ListTile(
          leading:
              const Icon(Icons.music_note, color: Colors.pinkAccent, size: 40),
          title: Text(widget.post.title),
          subtitle: Text(widget.post.description.toString()),
          trailing: Text(timeago.format(widget.post.date)),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PostDetail(post: widget.post)));
          },
        ),
      ),
    );
  }
}
