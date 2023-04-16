import 'package:flutter/foundation.dart';

class Person extends ChangeNotifier{
  Person({
    required this.name,
    required this.email,
    required this.age,
    required this.gender,
    required this.uid,
    required this.emergencyContacts,
  });

  String name;
  String email;
  String age;
  String gender;
  String uid;
  List<String> emergencyContacts;

 static fromJson(Map<dynamic, dynamic> json) => Person(
    name: json["name"],
    email: json["email"],
    age: json["age"],
    gender: json["gender"],
    uid: json["uid"],
    emergencyContacts: List<String>.from(json["emergency_contacts"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "age": age,
    "gender": gender,
    "uid": uid,
    "emergency_contacts": List<dynamic>.from(emergencyContacts.map((x) => x)),
  };

}