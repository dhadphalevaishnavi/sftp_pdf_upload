import 'package:flutter/material.dart';
import 'package:pdf_generator_sftp_upload/CustomWidgets/customButton.dart';
import 'package:pdf_generator_sftp_upload/Services/operationService.dart';
import 'package:pdf_generator_sftp_upload/constants.dart';

import '../Services/validationService.dart';

class EnterEmailScreen extends StatelessWidget {
  EnterEmailScreen({super.key, required this.buttonColor, required this.text});

  final emailController = TextEditingController();
  final Color buttonColor;
  final String text;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Enter Email",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                const SizedBox(height: 12),
                _emailField(),
                const SizedBox(height: 12),
                CustomButton(
                    onPressedAction: () {
                      if (formKey.currentState!.validate()) {
                        text == DELETE
                            ? OperationService.deleteRecord(emailController.text)
                            : OperationService.updateRecord(
                                emailController.text, context);
                      }
                    },
                    text: text)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailField() {
    return Form(
      key: formKey,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: emailController,
        maxLength: 60,
        decoration: const InputDecoration(
            counterText: "",
            filled: true,
            prefixIcon: Icon(Icons.email),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25))),
            hintText: "abc23@yahoo.com",
            labelText: "Email"),
        validator: ValidationService.emailValidator,
      ),
    );
  }
}
