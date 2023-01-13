import 'dart:convert';

import 'package:firebase_test/classes/post.dart';
import 'package:firebase_test/firebase_controllers/firestore_controller.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatefulWidget {
  //list post
  final firestore = Firestore();
  final Post post;
  PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    ///timeago.setLocaleMessages('es', timeago.EsMessages());
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: MemoryImage(base64Decode(widget.post.file)),
        ),
        title: Text(
          widget.post.title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        subtitle: Text(
          widget.post.description,
          style: const TextStyle(
              fontWeight: FontWeight.normal, fontSize: 15, color: Colors.white),
        ),
        trailing: Text(timeago.format(widget.post.date)),
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                icon: const Icon(Icons.delete),
                title: const Text('Eliminar'),
                content: const Text('¿Desea eliminar este post?'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancelar')),
                  TextButton(
                      onPressed: () {
                        widget.firestore.destroyPost(widget.post.id);
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                      child: const Text('Eliminar'))
                ],
              );
            },
          );
        },
      ),
    );
  }
}
