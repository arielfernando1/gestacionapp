import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/classes/user.dart';
import 'package:firebase_test/firebase_controllers/firestore_controller.dart';
import 'package:firebase_test/widgets/cards/photo_card.dart';
import 'package:firebase_test/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';

import '../../classes/post.dart';

class BitacoraPage extends StatefulWidget {
  final firestore = Firestore();
  BitacoraPage({super.key});

  @override
  State<BitacoraPage> createState() => _BitacoraPageState();
}

class _BitacoraPageState extends State<BitacoraPage> {
  FirebaseAuth? instance;
  User? u;
  @override
  void initState() {
    super.initState();
    //widget.firestore.listAll();
  }

  @override
  Widget build(BuildContext context) {
    instance = FirebaseAuth.instance;
    u = instance!.currentUser;
    // ignore: unnecessary_null_comparison
    if (instance == null) {
      return const Scaffold(
        body: Center(
          child: Text('No hay usuario'),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Bitacora'),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: FutureBuilder<List<Post>>(
          future: widget.firestore.listAll(u!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final posts = snapshot.data;
              return ListView.builder(
                  itemCount: posts!.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    // if (post.postType == 1) {
                    // return card with post file as image that is in base64
                    return CardContainer(post: post);
                    // } else if (post.postType == 2) {
                    //   // return card with post info audio and date and icon
                    //   return Card(
                    //     // card size
                    //     child: ListTile(
                    //       leading: const Icon(Icons.audiotrack,
                    //           color: Colors.pink, size: 40),
                    //       title: Text(post.title),
                    //       subtitle: Text(post.description),
                    //       trailing: Text(post.date.toString()),
                    //     ),
                    //   );
                    // } else {
                    //   // return card with post info text and date and icon
                    //   return Card(
                    //     child: ListTile(
                    //       leading: const Icon(Icons.abc,
                    //           color: Colors.green, size: 40),
                    //       title: Text(post.title),
                    //       subtitle: Text(post.description),
                    //       trailing: Text(post.date.toString()),
                    //     ),
                    //   );
                  }
                  // },
                  );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
            overlayStyle: ExpandableFabOverlayStyle(blur: 10),
            children: [
              FloatingActionButton(
                onPressed: () {
                  // go to add photo page
                  Navigator.pushNamed(context, '/photo').then((value) =>
                      setState(
                          () {})); // when the page is closed, refresh the page
                },
                child: const Icon(Icons.image),
              ),
              FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/audio')
                      .then((value) => setState(() {}));
                },
                child: const Icon(Icons.audiotrack),
              ),
              FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.abc),
              ),
            ]),
      );
    }
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.secondary,
      elevation: 4.0,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: theme.colorScheme.onSecondary,
      ),
    );
  }
}
