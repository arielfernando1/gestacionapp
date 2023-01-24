import 'dart:convert';

import 'package:firebase_test/firebase_controllers/firestore_controller.dart';
import 'package:firebase_test/pages/info/book_detail.dart';
import 'package:flutter/material.dart';

import '../../classes/book.dart';

class BookPage extends StatefulWidget {
  final firestore = Firestore();

  BookPage({super.key});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: widget.firestore.listAllBooks(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              // book card with image
              return Card(
                  child: ListTile(
                // leading memory image
                leading: Image.memory(
                  base64Decode(snapshot.data![index].image),
                  // max size
                  width: 50,
                  fit: BoxFit.fitHeight,
                ),
                title: Text(snapshot.data![index].title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(snapshot.data![index].description),
                // tooltip
                trailing: const Tooltip(
                  message: 'Ver más',
                  child: Icon(Icons.open_in_browser),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => BookDetail(
                                book: snapshot.data![index],
                              ))));
                },
              ));
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const Center(
            child: CircularProgressIndicator(
          color: Colors.blue,
        ));
      },
    );
  }
}
