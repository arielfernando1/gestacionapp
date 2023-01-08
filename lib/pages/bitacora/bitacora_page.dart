import 'dart:convert';

import 'package:firebase_test/classes/user.dart';
import 'package:firebase_test/firebase_controllers/firestore_controller.dart';
import 'package:firebase_test/firebase_controllers/storage_controller.dart';
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
  late CurrentUser user = CurrentUser();
  @override
  void initState() {
    super.initState();
    //widget.firestore.listAll();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<CurrentUser>(context);
    final u = user.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitacora'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Post>>(
        future: widget.firestore.listAll(u!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final posts = snapshot.data;
            return ListView.builder(
              itemCount: posts!.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                if (post.postType == 1) {
                  // return card with post file as image that is in base64
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    // ignore: sort_child_properties_last
                    child: Card(
                      child: ListTile(
                        // leading with circle avatar
                        leading: CircleAvatar(
                          radius: 48,
                          backgroundImage: MemoryImage(
                            base64Decode(post.file),
                          ),
                        ),
                        title: Text(
                          post.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        subtitle: Text(
                          post.description,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white),
                        ),
                        //trailing: Text(post.date.toString()),
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Eliminar'),
                                content:
                                    const Text('¿Desea eliminar este post?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      widget.firestore.destroyPost(post.id);
                                      setState(() {});
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Eliminar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(
                          base64Decode(post.file),
                        ),
                        fit: BoxFit.fitWidth,
                        opacity: 0.5,
                      ),
                    ),
                    // date and icon
                  );
                } else if (post.postType == 2) {
                  // return card with post info audio and date and icon
                  return Card(
                    // card size
                    child: ListTile(
                      leading: const Icon(Icons.audiotrack,
                          color: Colors.pink, size: 40),
                      title: Text(post.title),
                      subtitle: Text(post.description),
                      trailing: Text(post.date.toString()),
                    ),
                  );
                } else {
                  // return card with post info text and date and icon
                  return Card(
                    child: ListTile(
                      leading:
                          const Icon(Icons.abc, color: Colors.green, size: 40),
                      title: Text(post.title),
                      subtitle: Text(post.description),
                      trailing: Text(post.date.toString()),
                    ),
                  );
                }
              },
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
                Navigator.pushNamed(context, '/photo').then((value) => setState(
                    () {})); // when the page is closed, refresh the page
              },
              child: const Icon(Icons.image),
            ),
            FloatingActionButton(
              onPressed: () {},
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
