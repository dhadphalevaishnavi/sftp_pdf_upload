import 'package:flutter/material.dart';
import 'package:pdf_generator_sftp_upload/CustomWidgets/customButton.dart';
import 'package:pdf_generator_sftp_upload/Screens/enterEmailScreen.dart';
import 'package:pdf_generator_sftp_upload/Services/toastService.dart';

import '../Services/dbService.dart';
import '../constants.dart';
import 'formScreen.dart';

class ChooseOperationScreen extends StatefulWidget {
  const ChooseOperationScreen({super.key});

  @override
  State<ChooseOperationScreen> createState() => _ChooseOperationScreenState();
}

class _ChooseOperationScreenState extends State<ChooseOperationScreen> {
  BuildContext? cont;

  @override
  void initState() {
    super.initState();

    //Establish DB Connection
    DatabaseService.connectDB().then((value) {
      if (value != null) {
        //DB connection successful
        ToastService.toast("DB Connection Successful!", Colors.green.shade300);
      } else {
        ToastService.toast("DB Connection Failed!", Colors.red.shade300);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    cont = context;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.blueGrey, Colors.black12],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Center(
            child: Text(
              "Choose Operation",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                    onPressedAction: () {
                      _addRecord();
                    },

                    text: "Add Record"),
                const SizedBox(height: 20),
                CustomButton(
                    onPressedAction: () {
                      _updateRecord();
                    },
                    text: "Update Record"),
                const SizedBox(height: 20),
                CustomButton(
                    onPressedAction: () {
                      _deleteRecord();
                    },
                    text: "Delete Record"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _addRecord() {
    Navigator.push(
        cont!, MaterialPageRoute(builder: (context) => FormScreen()));
  }

  _updateRecord() {
    Navigator.push(
        cont!,
        MaterialPageRoute(
            builder: (context) => EnterEmailScreen(
                  buttonColor: Colors.blueAccent.shade100,
                  text: UPDATE,
                )));
  }

  _deleteRecord() {
    Navigator.push(
        cont!,
        MaterialPageRoute(
            builder: (context) => EnterEmailScreen(
                  buttonColor: Colors.redAccent.shade100,
                  text: DELETE,
                )));
  }
}
