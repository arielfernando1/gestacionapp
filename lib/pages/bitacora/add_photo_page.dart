import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/classes/post.dart';
import 'package:firebase_test/firebase_controllers/firestore_controller.dart';
import 'package:firebase_test/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';

// ignore: must_be_immutable
class PhotoPage extends StatefulWidget {
  Firestore firestore = Firestore();

  PhotoPage({super.key});
  // save to firestore
  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  late User user;
  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    String? path;
    String? base64;
    final formKey = GlobalKey<FormState>();
    user = FirebaseAuth.instance.currentUser!;
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
                validator: (value) =>
                    value!.isEmpty ? 'Titulo requerido' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Descripcion',
                ),
                controller: descriptionController,
                maxLines: 4,
                validator: (value) =>
                    value!.isEmpty ? 'Descripcion requerida' : null,
              ),
              FormBuilderImagePicker(
                  cameraLabel: const Text('Tomar foto'),
                  galleryLabel: const Text('Seleccionar de galeria'),
                  validator: (value) =>
                      value!.isEmpty ? 'Imagen requerida' : null,
                  name: 'image',
                  maxImages: 1,
                  // get image path
                  onChanged: (value) {
                    path = value!.first.path;
                    // convert to base64
                    final bytes = File(path!).readAsBytesSync();
                    base64 = base64Encode(bytes);
                  }),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: (() async {
                    if (formKey.currentState!.validate()) {
                      await savePost1(titleController.text,
                          descriptionController.text, base64!, user.uid);
                      // pop until home
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Foto guardada correctamente'),
                        ),
                      );
                    }
                  }),
                  child: const Text('Guardar')),
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
  void savePost(
      String title, String description, String base64, String uuid) async {
    // create post instance
    final post = Post(
        id: '',
        uuid: uuid,
        date: DateTime.now(),
        title: title,
        description: description,
        file: base64,
        postType: 1);
    // save post
    await widget.firestore.addPost(post);
  }

  Future<void> savePost1(
      String title, String description, String base64, String uuid) async {
    // create post instance
    final post = Post(
        id: '',
        uuid: uuid,
        date: DateTime.now(),
        title: title,
        description: description,
        file: base64,
        postType: 1);
    // save post
    await widget.firestore.addPost(post);
  }
}
