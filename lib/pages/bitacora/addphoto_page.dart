import 'dart:convert';
import 'dart:io';

import 'package:firebase_test/classes/post.dart';
import 'package:firebase_test/classes/user.dart';
import 'package:firebase_test/firebase_controllers/firestore_controller.dart';
import 'package:flutter/material.dart';
// import filepicker
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key});

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  late CurrentUser user = CurrentUser();
  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    Firestore firestore = Firestore();
    user = Provider.of<CurrentUser>(context);
    final u = user.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Foto'),
      ),
      body: Form(
          key: formKey,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Titulo',
                ),
                controller: titleController,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Descripcion',
                ),
                controller: descriptionController,
                maxLines: 12,
                validator: (value) =>
                    value!.isEmpty ? 'Descripcion requerida' : null,
              ),
              ElevatedButton(
                  onPressed: (() async {
                    // validate form
                    final results = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                      allowMultiple: false,
                    );
                    final path = results!.files.single.path;
                    //convert to base64
                    final bytes = File(path!).readAsBytesSync();
                    final base64 = base64Encode(bytes);
                    //get current user id

                    // create post instance
                    final post = Post(
                        id: '',
                        uuid: u!,
                        date: DateTime.now(),
                        title: titleController.text,
                        description: descriptionController.text,
                        file: base64,
                        postType: 1);
                    // save post
                    await firestore.addPost(post);
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  }),
                  child: const Text('Seleccionar Foto')),
            ]),
          )),
    );
  }
// convert ptoho
  //   return Scaffold(
  //       appBar: AppBar(
  //         title: const Text('Añadir Foto'),
  //       ),
  //       body: Column(
  //         // ignore: prefer_const_literals_to_create_immutables
  //         children: [
  //           //button
  //           TextButton(
  //               onPressed: () async {
  //                 // open file picker
  //                 final results = await FilePicker.platform.pickFiles(
  //                   type: FileType.image,
  //                   allowMultiple: false,
  //                 );
  //                 // ignore: unnecessary_null_comparison
  //                 if (results == null) {
  //                   // ignore: use_build_context_synchronously
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     const SnackBar(
  //                       content: Text('No se ha seleccionado ninguna foto'),
  //                     ),
  //                   );
  //                   return;
  //                 }
  //                 final path = results.files.single.path;
  //                 final filename = results.files.single.name;
  //                 storage
  //                     .uploadFile(path!, filename)
  //                     .then((value) => log('File uploaded successfully'));
  //               },
  //               child: const Text('Seleccionar Foto')),
  //         ],
  //       ),
  //       floatingActionButton: FloatingActionButton(
  //         onPressed: () {
  //           storage.uploadFile('path', 'filename');
  //         },
  //         child: const Icon(Icons.save),
  //       ));
  // }
}
