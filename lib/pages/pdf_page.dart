import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../classes/post.dart';
import '../firebase_controllers/firestore_controller.dart';
import 'bitacora_generator.dart';

class PdfPage extends StatefulWidget {
  final firestore = Firestore();
  PdfPage({super.key});

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  FirebaseAuth? instance;
  User? u;
  @override
  Widget build(BuildContext context) {
    instance = FirebaseAuth.instance;
    u = instance!.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exportar'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder<List<Post>>(
        future: widget.firestore.listAll(u!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PdfPreview(
              canDebug: false,
              canChangePageFormat: false,
              build: (format) => generatePdf(format, snapshot.data!),
              // show snackbar on share
              maxPageWidth: 600,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
