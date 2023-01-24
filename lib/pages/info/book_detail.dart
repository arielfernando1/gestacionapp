import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import '../../classes/book.dart';

// ignore: must_be_immutable
class BookDetail extends StatefulWidget {
  Book book;
  BookDetail({super.key, required this.book});

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(blurRadius: 32, color: Colors.pinkAccent)
            ]),
            child: Image(image: MemoryImage(base64Decode(widget.book.image))),
          ),
          const SizedBox(height: 16),
          Text(widget.book.title),
          const SizedBox(height: 16),
          Text(
            widget.book.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person),
              const SizedBox(width: 12),
              Text(widget.book.author)
            ],
          ),
          const SizedBox(height: 30),
          FloatingActionButton(
            child: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              log('Open PDF');
            },
          )
        ],
      ),
    );
  }
}
