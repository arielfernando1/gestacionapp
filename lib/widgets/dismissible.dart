import 'package:flutter/material.dart';

import '../firebase_controllers/firestore_controller.dart';

class MyDismisible extends StatefulWidget {
  final firestore = Firestore();

  final Key keys;
  final Widget child;
  final String postid;
  MyDismisible(
      {super.key,
      required this.child,
      required this.keys,
      required this.postid});

  @override
  State<MyDismisible> createState() => _MyDismisibleState();
}

class _MyDismisibleState extends State<MyDismisible> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        // text "Delete" and icon
        color: Theme.of(context).errorColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
              size: 48,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: Colors.black,
                  offset: Offset(5.0, 5.0),
                ),
              ],
            ),
          ],
        ),
      ),
      key: widget.keys,
      child: widget.child,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).backgroundColor,
              icon: const Icon(Icons.delete),
              title: const Text("Confirmar"),
              content: const Text(
                "¿Estás seguro de eliminar este recuerdo?",
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => widget.firestore
                      .destroyPost(widget.postid)
                      .then((value) => Navigator.of(context).pop(true)),
                  child: const Text("Eliminar"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancelar"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
