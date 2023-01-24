import 'package:flutter/material.dart';

import 'book_page.dart';
import 'contact_page.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    // return two centered buttons with icons
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,

          title: const Text("Informate"),
          // no back button
          automaticallyImplyLeading: false,
          // ignore: prefer_const_constructors
          bottom: TabBar(
            // ignore: prefer_const_literals_to_create_immutables
            tabs: [
              const Tab(icon: Icon(Icons.book)),
              const Tab(icon: Icon(Icons.chat)),
            ],
          ),
        ),
        // ignore: prefer_const_constructors
        body: TabBarView(
          // get books from firestore
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            BookPage(),
            const ContactPage(),
          ],
        ),
      ),
    );
  }
}
