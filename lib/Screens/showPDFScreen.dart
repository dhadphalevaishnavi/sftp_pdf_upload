import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ShowPDFScreen extends StatelessWidget {

  final String pdfFilePath;
  const ShowPDFScreen({super.key, required this.pdfFilePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF Preview"),),
      body: SfPdfViewer.file(File(pdfFilePath)),
    );

  }
}
