import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  ObjectId? id;
  final String name, email, address, date, age, gender, empStatus;

  User(
      {this.id,
      required this.name,
      required this.email,
      required this.address,
      required this.age,
      required this.date,
      required this.empStatus,
      required this.gender});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        address: json["address"],
        date: json["dob"],
        gender: json["gender"],
        age: json["age"],
        empStatus: json["empStatus"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "address": address,
        "dob": date,
        "gender": gender,
        "age": age,
        "empStatus": empStatus,
      };
}
