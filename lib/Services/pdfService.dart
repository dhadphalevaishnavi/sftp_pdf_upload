import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_generator_sftp_upload/Screens/showPDFScreen.dart';

import '../Model/user.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfwidget;

class PDFService {
  final User user;
  final pdf = pdfwidget.Document();
  String pdfFilePath = "";

  PDFService({
    required this.user,
  });

  writePDF() async {
    pdf.addPage(pdfwidget.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pdfwidget.EdgeInsets.all(45),
        build: (pdfwidget.Context context) {
          return <pdfwidget.Widget>[
            pdfwidget.Center(
              child: pdfwidget.Column(
                mainAxisAlignment: pdfwidget.MainAxisAlignment.center,
                children: [
                  pdfwidget.Text(user.name,
                      style: const pdfwidget.TextStyle(fontSize: 40)),
                  pdfwidget.Text(user.email,
                      style: const pdfwidget.TextStyle(fontSize: 20)),
                  pdfwidget.SizedBox(height: 30),
                  pdfwidget.Table(
                      border: pdfwidget.TableBorder.all(),
                      defaultVerticalAlignment: pdfwidget.TableCellVerticalAlignment.middle,
                      children: [
                        _tableRow("Gender", user.gender),
                        _tableRow("Date of Birth", user.date),
                        _tableRow("Age", user.age),
                        _tableRow("Address", user.address),
                        _tableRow("Employment Status", user.empStatus)
                      ]),
                ],
              ),
            ),
          ];
        }));
  }

  Future<String?> savePDF(ObjectId? objectId) async {
    Directory docDirectory = await getApplicationDocumentsDirectory();
    String docPath = docDirectory.path;
    //save pdf by emailId as name
    pdfFilePath = "$docPath/$objectId.pdf";
    File file = File(pdfFilePath);
    file.writeAsBytesSync(await pdf.save());
    return pdfFilePath;
  }

  openPDF(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ShowPDFScreen(pdfFilePath: pdfFilePath)));
  }

  _tableRow(String title, String value) {
    return pdfwidget.TableRow(children: [
      pdfwidget.Padding(
          padding: const pdfwidget.EdgeInsets.all(16),
          child: pdfwidget.Text(title,
              style: const pdfwidget.TextStyle(fontSize: 20))),
      pdfwidget.Padding(
          padding: const pdfwidget.EdgeInsets.all(16),
          child: pdfwidget.Text(value,
              style: const pdfwidget.TextStyle(fontSize: 20))),
    ]);
  }
}
