import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/firebase_controllers/firestore_controller.dart';
import 'package:firebase_test/pages/pdf_page.dart';
import 'package:firebase_test/widgets/cards/audio_card.dart';
import 'package:firebase_test/widgets/cards/photo_card.dart';
import 'package:firebase_test/widgets/dismissible.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

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
    log('BitacoraPage: initState()');
    super.initState();
  }
  // set state

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
          title: const Text('Mi Album'),
          automaticallyImplyLeading: false,
          centerTitle: true,
          // three dots menu
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.picture_as_pdf,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 8),
                      Text('Exportar'),
                    ],
                  ),
                  onTap: () => Future(() => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => PdfPage()))),
                )
                // toggle dark mode
              ],
            ),
          ],
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
                    switch (post.postType) {
                      case 1:
                        return MyDismisible(
                            postid: post.id,
                            keys: UniqueKey(),
                            child: PhotoCard(
                              post: post,
                            ));
                      case 2:
                        return MyDismisible(
                            keys: UniqueKey(),
                            postid: post.id,
                            child: AudioCard(post: post));
                      // return AudioCard(
                      //   post: post,
                      //   alertDialog: AlertDialog(
                      //     icon: const Icon(Icons.audiotrack),
                      //     title: const Text('Eliminar'),
                      //     content: const Text(
                      //         '¿Estás seguro de eliminar este post?'),
                      //     actions:
                      //       TextButton(
                      //         onPressed: () {
                      //           Navigator.pop(context);
                      //         },
                      //         child: const Text('Cancelar'),
                      //       ),
                      //       TextButton(
                      //         onPressed: () {
                      //           widget.firestore.destroyPost(post.id);
                      //           setState(() {});
                      //           Navigator.pop(context);
                      //         },
                      //         child: const Text('Eliminar'),
                      //       ),
                      //     ],
                      //   ),
                      // );

                      default:
                        return const Text('Error');
                    }

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
                heroTag: "btn1",
                onPressed: () {
                  // go to add photo page
                  Navigator.pushNamed(context, '/photo').then((value) =>
                      setState(
                          () {})); // when the page is closed, refresh the page
                },
                child: const Icon(Icons.image),
              ),
              FloatingActionButton(
                heroTag: "btn2",
                onPressed: () {
                  Navigator.pushNamed(context, '/audio')
                      .then((value) => setState(() {}));
                },
                child: const Icon(Icons.mic),
              ),
              FloatingActionButton(
                heroTag: "btn3",
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
