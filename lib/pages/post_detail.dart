// ignore_for_file: implementation_imports, unrelated_type_equality_checks
import 'dart:developer';
import 'package:firebase_test/firebase_controllers/firestore_controller.dart';
import 'package:firebase_test/pages/photo_page.dart';
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
        ? PhotoDetail(post: widget.post)
        : widget.post.postType == 2
            ? AudioDetail(post: widget.post)
            : Container();
  }
}
