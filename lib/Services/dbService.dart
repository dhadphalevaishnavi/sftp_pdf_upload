import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:pdf_generator_sftp_upload/Services/toastService.dart';

import '../Model/user.dart';
import '../constants.dart';

class DatabaseService {
  static DbCollection? collection;

  static Future<DbCollection?> connectDB() async {
    try {
      var db = await Db.create(DB_URL);
      await db.open();

      var collectionVar = db.collection(COLLECTION_NAME);
      collection = collectionVar;
      return collection;
    } catch (e) {
      ToastService.toast(
          "Something went wrong while connecting to DB", Colors.red.shade300);
      print(e.toString());
    }
  }

  static Future<ObjectId?> insert(User user) async {
    try {
      var result = await collection?.insertOne(user.toJson());
      if (result!.isSuccess) {
        print(result.id);
        ToastService.toast("Record Inserted in DB", Colors.green.shade300);

        return result.id;
      } else {
        ToastService.toast("Inserting in DB FAILED", Colors.red.shade300);
      }

    } catch (e) {
      ToastService.toast(
          "Something went wrong while 'Inserting' user", Colors.red.shade300);
      print(e.toString());

    }
  }

  static Future<bool?> update(ObjectId? userId, User updatedUser) async {
    try {
      WriteResult? result = await collection?.updateOne(
          where.eq("_id", userId!),
          modify
              .set('name', updatedUser.name)
              .set('email', updatedUser.email)
              .set('address', updatedUser.address)
              .set('dob', updatedUser.date)
              .set('age', updatedUser.age)
              .set('gender', updatedUser.gender)
              .set('empStatus', updatedUser.empStatus));

      if (result!.isSuccess) {
        ToastService.toast("DB Record Updated", Colors.green.shade300);
        return true;
      } else {
        ToastService.toast("DB Record Update Failed", Colors.red.shade300);
      }
    } catch (e) {
      ToastService.toast(
          "Something went wrong while 'updating' user", Colors.red.shade300);
      print(e.toString());
    }
  }

  static Future<bool?> delete(String email) async {
    try {
      WriteResult? result = await collection?.deleteOne({"email": email});
      if (result!.isSuccess) {
        ToastService.toast("DB Record Deleted ", Colors.green.shade300);
        return true;
      } else {
        ToastService.toast("DB Record 'Deletion' Failed", Colors.red.shade300);
      }
    } catch (e) {
      ToastService.toast(
          "Something went wrong while 'Deleting' user", Colors.red.shade300);
      print(e.toString());
    }
  }

  static Future<User?> findByEmail(String email) async {
    try {
      var user = await collection?.findOne({"email": email});
      if (user != null) {
        return User.fromJson(user!);
      } else {
        ToastService.toast("$email not found", Colors.red.shade300);
      }
    } catch (e) {
      ToastService.toast("Something went wrong while 'Finding' user by Email",
          Colors.red.shade300);
      print(e.toString());
    }
  }
}
