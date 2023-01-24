import 'dart:convert';
import 'dart:developer';

import 'package:firebase_test/classes/post.dart';
import 'package:firebase_test/firebase_controllers/firestore_controller.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../pages/post_detail.dart';

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
    log('PhotoCard: initState()');
  }

  @override
  Widget build(BuildContext context) {
    timeago.setDefaultLocale('es');
    return Container(
      margin: const EdgeInsets.all(6.00),
      // ignore: prefer_const_constructors
      decoration: BoxDecoration(
        // ignore: prefer_const_constructors
        // ignore: prefer_const_literals_to_create_immutables
        boxShadow: [
          // ignore: prefer_const_constructors
          BoxShadow(
              color: const Color.fromRGBO(255, 175, 204, 1),
              blurRadius: 15,
              offset: const Offset(4, 4))
        ],
        // image: DecorationImage(
        //   image: MemoryImage(
        //     base64Decode(widget.post.file),
        //   ),
        //   fit: BoxFit.fitWidth,
        //   opacity: 0.5,
        // ),
      ),
      child: Card(
        color: Colors.grey[300],
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
          onTap: () {
            Navigator.push(
              context,
              createRoute(),
            ).then((value) => setState(() {}));
          },
          onLongPress: () {
            Navigator.pushNamed(context, '/edit_post', arguments: widget.post);
          },
        ),
      ),
    );
  }

  Route createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PostDetail(
        post: widget.post,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
