import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../classes/post.dart';

// ignore: must_be_immutable
class PhotoDetail extends StatefulWidget {
  Post post;
  PhotoDetail({super.key, required this.post});

  @override
  State<PhotoDetail> createState() => _PhotoDetailState();
}

class _PhotoDetailState extends State<PhotoDetail> {
  @override
  Widget build(BuildContext context) {
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
}
