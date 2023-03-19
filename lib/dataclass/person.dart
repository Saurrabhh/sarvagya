import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../firebase/firebase_manager.dart';

final FirebaseAuth auth = FirebaseManager.auth;
final FirebaseDatabase database = FirebaseManager.database;

class Person{
  late String name;
  late String email;
  late String phone;
  late String uid;
  late String age;
  late List<String>? emergencyContact;
  // Person(
  //     {
  //       required this.name,
  //       required this.email,
  //       required this.phone,
  //       required this.uid,
  //       this.emergencyContact,
  //     }
  //     );

  void fromJson(Map<String?, dynamic> json) {
     name = json['name'];
     phone = json['phone'];
     email = json['email'];
     uid = json['uid'];
     age = json['age'];
     emergencyContact = json['emergencyContact'];
  }

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'email': email,
        'phone': phone,
        'uid': uid,
        'age': age,
        'emergencyContact' : emergencyContact,
      };

}