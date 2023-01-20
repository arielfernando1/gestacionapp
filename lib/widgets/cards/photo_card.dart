import 'dart:convert';

import 'package:firebase_test/classes/post.dart';
import 'package:firebase_test/firebase_controllers/firestore_controller.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: must_be_immutable
class PhotoCard extends StatefulWidget {
  final firestore = Firestore();
  final Post post;
  //AlertDialog alertDialog;
  // context
  PhotoCard({super.key, required this.post});

  @override
  State<PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<PhotoCard> {
  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('es', timeago.EsMessages());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6.00),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: MemoryImage(
            base64Decode(widget.post.file),
          ),
          fit: BoxFit.fitWidth,
          opacity: 0.5,
        ),
      ),
      child: Card(
        color: Colors.transparent,
        child: ListTile(
          leading: CircleAvatar(
            radius: 24,
            backgroundImage: MemoryImage(base64Decode(widget.post.file)),
          ),
          title: Text(
            widget.post.title,
            style: Theme.of(context).textTheme.headline1,
          ),
          subtitle: Text(
            widget.post.description,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          trailing: Text(timeago.format(widget.post.date)),
          onLongPress: () {},
          // onLongPress: () {
          //   showDialog(
          //     context: context,
          //     builder: (context) {
          //       return widget.alertDialog;
          //     },
          //   );
          // },
        ),
      ),
    );
  }
}
