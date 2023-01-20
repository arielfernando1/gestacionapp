import 'dart:convert';

import 'package:firebase_test/classes/post.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generatePdf(PdfPageFormat format, List<Post> list) async {
  final pdf = pw.Document();
  final shape = await rootBundle.loadString('assets/bg1.svg');
  // array of shapes
  //final shapes = [shape, shape1, shape2];
  list = list.where((element) => element.postType == 1).toList();
  pdf.addPage(pw.MultiPage(
    pageTheme: pw.PageTheme(
      pageFormat: format.copyWith(
        marginBottom: 0,
        marginLeft: 0,
        marginRight: 0,
        marginTop: 0,
      ),
      buildBackground: (pw.Context context) {
        return pw.SvgImage(
          svg: shape,
          fit: pw.BoxFit.fill,
          //add transparency
        );
      },
    ),
    build: (pw.Context context) {
      return <pw.Widget>[
        for (var i = 0; i < list.length; i++)
          pw.Container(
              padding: const pw.EdgeInsets.all(10),
              margin: const pw.EdgeInsets.all(16),
              child: pw.Container(
                  child: pw.Column(children: <pw.Widget>[
                pw.Image(
                  pw.MemoryImage(
                    base64Decode(list[i].file),
                  ),
                  alignment: pw.Alignment.center,
                  height: 200,
                ),
                // title
                pw.Container(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: <pw.Widget>[
                      pw.Text(
                        list[i].title,
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        list[i].description,
                        style: pw.TextStyle(
                          fontSize: 15,
                          fontWeight: pw.FontWeight.normal,
                        ),
                      ),
                      // date
                      pw.Text(list[i].date.toString(),
                          style: pw.TextStyle(
                            fontSize: 15,
                            fontWeight: pw.FontWeight.normal,
                          )),
                    ],
                  ),
                ),
              ]))),
        // file and title
      ];
    },
  ));

  return pdf.save();
}
