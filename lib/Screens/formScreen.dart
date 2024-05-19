import 'package:flutter/material.dart';
import 'package:pdf_generator_sftp_upload/Model/user.dart';
import 'package:pdf_generator_sftp_upload/Services/dbService.dart';
import 'package:pdf_generator_sftp_upload/Services/operationService.dart';
import 'package:pdf_generator_sftp_upload/Services/pdfService.dart';
import 'package:pdf_generator_sftp_upload/Services/validationService.dart';

import '../Services/sftpService.dart';
import '../constants.dart';

class FormScreen extends StatefulWidget {
  User? userToUpdate;

  //to find PDF file name on Server (in case user updates email)
  String? oldEmail;

  FormScreen({super.key, this.userToUpdate, this.oldEmail});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();
  String genderGroupVal = "";
  String empStatusGroupVal = "";
  String selectedGender = "";
  String selectedEmpStatus = "";

  TextEditingController? nameController;
  TextEditingController? emailController;
  TextEditingController? addressController;
  TextEditingController? dateController;
  TextEditingController? ageController;

  User? userToUpdate;

  @override
  void initState() {
    super.initState();
    userToUpdate = widget.userToUpdate;
    nameController = TextEditingController(
        text: userToUpdate != null ? userToUpdate!.name : "");
    emailController = TextEditingController(
        text: userToUpdate != null ? userToUpdate!.email : "");
    addressController = TextEditingController(
        text: userToUpdate != null ? userToUpdate!.address : "");
    dateController = TextEditingController(
        text: userToUpdate != null ? userToUpdate!.date : "");
    ageController = TextEditingController(
        text: userToUpdate != null ? userToUpdate!.age : "");

    selectedGender = userToUpdate != null ? userToUpdate!.gender : "";
    selectedEmpStatus = userToUpdate != null ? userToUpdate!.empStatus : "";

    genderGroupVal = selectedGender!;
    empStatusGroupVal = selectedEmpStatus!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.blueGrey , Colors.black12],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Center(
              child: Text(
            "User Information",
            style: TextStyle(color: Colors.white),
          )),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _nameField(),
                    const SizedBox(height: 12),
                    _emailField(),
                    const SizedBox(height: 12),
                    _addressField(),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _dateField(),
                        _ageField(),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _genderContainer(),
                    genderGroupVal == radioNotSelected
                        ? const Text("Select Gender",
                            style: TextStyle(color: Colors.red))
                        : const SizedBox(),
                    const SizedBox(height: 12),
                    _empStatusContainer(),
                    empStatusGroupVal == radioNotSelected
                        ? const Text("Select employment status",
                            style: TextStyle(color: Colors.red))
                        : const SizedBox(),
                    const SizedBox(height: 25),
                    _button(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _nameField() {
    return TextFormField(
      controller: nameController,
      maxLength: 30,
      decoration: const InputDecoration(
          counterText: "",
          filled: true,
          prefixIcon: Icon(Icons.person),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          hintText: "John Doe",
          labelText: "Name"),
      validator: ValidationService.nameValidator,
    );
  }

  Widget _emailField() {
    return TextFormField(
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
    );
  }

  Widget _addressField() {
    return TextFormField(
      controller: addressController,
      maxLength: 130,
      decoration: const InputDecoration(
          counterText: "",
          filled: true,
          prefixIcon: Icon(Icons.location_on),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          hintText: "167, Satara road, Pune-88",
          labelText: "Address"),
      validator: ValidationService.addressValidator,
    );
  }

  _dateField() {
    return SizedBox(
      width: 200,
      child: TextFormField(
        controller: dateController,
        validator: ValidationService.dateValidator,
        onTap: () => _selectDate(context, dateController!),
        readOnly: true,
        decoration: const InputDecoration(
            filled: true,
            counterText: "",
            prefixIcon: Icon(Icons.calendar_today),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25))),
            labelText: "Date of Birth"),
      ),
    );
  }

  _ageField() {
    return SizedBox(
      width: 100,
      child: TextFormField(
        controller: ageController,
        keyboardType: TextInputType.number,
        maxLength: 2,
        decoration: const InputDecoration(
            counterText: "",
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25))),
            hintText: "27",
            labelText: "Age"),
        validator: ValidationService.ageValidator,
      ),
    );
  }

  _genderContainer() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 224, 226, 1),
        border: Border.all(
            color: genderGroupVal.isEmpty ? Colors.black : Colors.red),
        borderRadius: const BorderRadius.all(Radius.circular(25)),
      ),
      child: Column(
        children: [
          Text(
            "Gender",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: genderGroupVal == radioNotSelected
                    ? Colors.red
                    : Colors.black),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Male"),
              Radio(
                  value: "Male",
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                      genderGroupVal = "Male";
                    });
                  }),
              const SizedBox(width: 30),
              const Text("Female"),
              Radio(
                  value: "Female",
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                      genderGroupVal = "Female";
                    });
                  }),
            ],
          ),
        ],
      ),
    );
  }

  _empStatusContainer() {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 224, 226, 1),
        border: Border.all(
            color: empStatusGroupVal.isEmpty ? Colors.black : Colors.red),
        borderRadius: const BorderRadius.all(Radius.circular(25)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "Employment Status",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: empStatusGroupVal == radioNotSelected
                      ? Colors.red
                      : Colors.black),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Employed"),
                Radio(
                    value: "Employed",
                    groupValue: selectedEmpStatus,
                    onChanged: (value) {
                      setState(() {
                        selectedEmpStatus = value!;
                        empStatusGroupVal = "Employed";
                      });
                    }),
                const SizedBox(width: 30),
                const Text("Unemployed"),
                Radio(
                    value: "Unemployed",
                    groupValue: selectedEmpStatus,
                    onChanged: (value) {
                      setState(() {
                        selectedEmpStatus = value!;
                        empStatusGroupVal = "Unemployed";
                      });
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _button() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          // style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.redAccent.shade100),
          onPressed: () => _generatePDF(context),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              "Generate/Update DB-PDF",
              style: TextStyle(fontSize: 20),
            ),
          )),
    );
  }

  _selectDate(
      BuildContext context, TextEditingController dateController) async {
    DateTime? chosenDate = await showDatePicker(
        context: context,
        firstDate: DateTime(1920),
        lastDate: DateTime(DateTime.now().year - 1),
        initialDate: DateTime(DateTime.now().year - 1));
    if (chosenDate != null) {
      dateController.text =
          "${chosenDate.day}/${chosenDate.month}/${chosenDate.year}";
      setState(() {});
    }
  }

  _generatePDF(BuildContext context) async {
    if (genderGroupVal.isEmpty || empStatusGroupVal.isEmpty) {
      if (genderGroupVal.isEmpty) {
        genderGroupVal = radioNotSelected;
      }
      if (empStatusGroupVal.isEmpty) {
        empStatusGroupVal = radioNotSelected;
      }
      setState(() {});
    }

    if (formKey.currentState!.validate()) {
      if (genderGroupVal != radioNotSelected &&
          empStatusGroupVal != radioNotSelected) {
        User user = User(
            name: nameController!.text,
            email: emailController!.text,
            address: addressController!.text,
            date: dateController!.text,
            age: ageController!.text,
            gender: genderGroupVal,
            empStatus: empStatusGroupVal);

        //Create PDFService object for PDF operations
        PDFService pdfService = PDFService(user: user);

        //if form not field when page loaded
        //Insert new record inDB
        if (userToUpdate == null) {
          OperationService.addRecord(user).then((objectId) {
            if (objectId != null) {
              //create and open PDF when DB insertion is successful
              pdfService.writePDF();
              pdfService.savePDF(objectId).then((pdfFilePath) {
                //if PDF is created
                if (pdfFilePath != null) {
                  //open PDF
                  pdfService.openPDF(context);
                  //upload pdf to SFTP Server
                  SftpService.uploadPDF(pdfFilePath);
                }
              });
            }
          });
        }
        //else Update record
        else {
          DatabaseService.update(userToUpdate!.id, user).then((updateStatus) {
            if (updateStatus == true) {
              //Update PDF when DB Update is successful
              pdfService.writePDF();
              pdfService.savePDF(userToUpdate!.id).then((pdfFilePath) {
                //if PDF is created
                if (pdfFilePath != null) {
                  //open PDF
                  pdfService.openPDF(context);
                  //upload pdf to SFTP Server
                  //pass old email to search pdf on server by oldEmail name
                  SftpService.updatePDF(userToUpdate!.id, pdfFilePath);
                }
              });
            }
          });
        }
      }
    }
  }
}
