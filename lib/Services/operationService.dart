import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:pdf_generator_sftp_upload/Screens/formScreen.dart';
import 'package:pdf_generator_sftp_upload/Services/sftpService.dart';
import 'package:pdf_generator_sftp_upload/Services/toastService.dart';

import '../Model/user.dart';
import 'dbService.dart';

class OperationService {
  static Future<ObjectId?> addRecord(User user) async {
    //check if DB connection is established
    if (DatabaseService.collection != null) {
      //Check if record with entered email already Exists in DB
      var dbUser = await DatabaseService.findByEmail(user.email);
      if (dbUser == null) {
        //if email doesn't exists then only add new record
        return DatabaseService.insert(user);

      } else {
        ToastService.toast(
            "${user.email} already exists!", Colors.red.shade300);
      }
    } else {
      ToastService.toast("DB Connection not active", Colors.red.shade300);
    }
  }

  static updateRecord(String email, BuildContext context) async {
    //check if DB connection is established
    if (DatabaseService.collection != null) {
      //Check if record with entered email already Exists in DB
      //get user record by email
      var dbUser = await DatabaseService.findByEmail(email);
      if (dbUser != null) {
        //if email exists then only update record
        //navigate to FormScreen
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FormScreen( oldEmail: email,
                      userToUpdate: dbUser,
                    )));
        // DatabaseService.update(dbUser.id, dbUser);
      }
    } else {
      ToastService.toast("DB Connection not active", Colors.red.shade300);
    }
  }

  static deleteRecord(String email) async {
    //check if DB connection is established
    if (DatabaseService.collection != null) {
      //Check if record with entered email already Exists in DB
      var dbUser = await DatabaseService.findByEmail(email);
      if (dbUser != null) {
        //if email exists then only delete record
        DatabaseService.delete(email).then((deletedFromDB){
          if(deletedFromDB == true){
            //delete PDF from SFTP Server
            SftpService.deletePdf(dbUser.id);
          }
        });
      }
    } else {
      ToastService.toast("DB Connection not active", Colors.red.shade300);
    }
  }
}
