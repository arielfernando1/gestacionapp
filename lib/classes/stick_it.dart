import 'dart:convert';
import 'dart:developer';
import 'package:firebase_test/classes/post.dart';
import 'package:firebase_test/firebase_controllers/firestore_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:stick_it/stick_it.dart';

import '../pages/home_page.dart';

// ignore: must_be_immutable
class StickerPage extends StatefulWidget {
  Post? post;
  StickerPage({super.key, this.post});

  @override
  State<StickerPage> createState() => _StickerPageState();
}

class _StickerPageState extends State<StickerPage> {
  Firestore firestore = Firestore();
  late StickIt stickIt;
  @override
  void initState() {
    super.initState();
    log('StickerPage: initState()');
  }

  @override
  Widget build(BuildContext context) {
    widget.post = ModalRoute.of(context)!.settings.arguments as Post;
    stickIt = StickIt(
        panelBackgroundColor: Theme.of(context).primaryColor,
        stickerList: [
          Image.asset('assets/stickers/001.png'),
          Image.asset('assets/stickers/002.png'),
          Image.asset('assets/stickers/003.png'),
          Image.asset('assets/stickers/004.png'),
          Image.asset('assets/stickers/005.png'),
        ],
        child: Image.memory(
          base64Decode(widget.post!.file),
          fit: BoxFit.scaleDown,
        ));
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(false);
        },
        child: Scaffold(
            // appbar with save button
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Editar Foto'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () async {
                    var image = await stickIt.exportImage();
                    // if image > 1048487 bytes, compress it
                    if (image.length > 1048487) {
                      image = await compressImage(image);
                      log('Compressed image size: ${image.length} bytes');
                    }
                    // if ( > 1000000) {
                    //   image = await compressImage(image);
                    //   log('Compressed image size: ${image.length} bytes');
                    // }
                    final imageBase64 = base64Encode(image);

                    final Post editedPost = Post(
                      uuid: widget.post!.uuid,
                      id: widget.post!.id,
                      file: imageBase64,
                      postType: widget.post!.postType,
                      date: widget.post!.date,
                      title: widget.post!.title,
                      description: widget.post!.description,
                    );
                    await editPost(editedPost);
                    // push to home page and remove previous screens
                    // ignore: use_build_context_synchronously
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                        (route) => false);

                    // print navigation stack                    log('Compressed image size: ${compressedImage.length} bytes');
                  },
                ),
              ],
            ),
            body: stickIt));
  }

  Future<void> editPost(Post editedPost) async {
    await firestore.updatePost(editedPost);
  }

  Future<Uint8List> compressImage(Uint8List image) async {
    final compressedImage = await FlutterImageCompress.compressWithList(
      image,
      quality: 75,
    );

    return compressedImage;
  }
}
