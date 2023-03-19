// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../dataclass/person.dart';
// import '../firebase/firebase_manager.dart';
//
// final TextEditingController ecPhone1Controller = TextEditingController();
// final TextEditingController ecPhone2Controller = TextEditingController();
//
// popup(BuildContext context) {
//
//   return showDialog(context: context, builder: (context){
//     return AlertDialog(
//       scrollable: true,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10.0))),
//       title: const Center(
//         child: Text('Add Emergency Contacts'),
//       ),
//       content: Form(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const SizedBox(
//               height: 20,
//             ),
//             Text('Emergency Contact 1'),
//             TextFormField(
//               controller: ecPhone1Controller,
//               decoration: const InputDecoration(
//                 labelText: 'Phone Number',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Text('Emergency Contact 2'),
//             TextFormField(
//               controller: ecPhone2Controller,
//               decoration: const InputDecoration(
//                 labelText: 'Phone Number',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//           ],
//         ),
//       ),
//       actions: <Widget>[
//         ElevatedButton(
//           onPressed: () => {Navigator.of(context).pop()},
//           style: ButtonStyle(
//             backgroundColor:
//             MaterialStateProperty.all(const Color(0xff1870B5)),
//             overlayColor: MaterialStateProperty.all<Color>(Colors.pink),
//           ),
//           child: const Text("Add Later"),
//         ),
//         ElevatedButton(
//           onPressed: () async => ecPhonePush(context),
//           style: ButtonStyle(
//             backgroundColor:
//             MaterialStateProperty.all(const Color(0xff1870B5)),
//             overlayColor: MaterialStateProperty.all<Color>(Colors.pink),
//           ),
//           child: const Text("Done"),
//         ),
//       ],
//     );
//   });
// }
//
// // ecPhonePush(BuildContext context) async {
// //   NavigatorState state = Navigator.of(context);
// //   print(auth.currentUser?.uid);
// //   final snapshot = await FirebaseManager.database.ref('Users/${auth.currentUser?.uid}').get();
// //   print(snapshot.value);
// //
// //   Map<String, dynamic> map = Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
// //   print(map);
// //   Person person;
// //   // person = Person.fromJson(map);
// //   // print(person);
// //   List<String>? exList= [ecPhone1Controller.text,ecPhone2Controller.text];
// //   print(exList);
// //
// //   map['emergencyContact'] = exList;
// //   print(map);
// //   print(auth.currentUser?.uid);
// //
// //   await database.ref('Users/${auth.currentUser?.uid}').update(map);
// //   print("Updated in DB");
// // }
//
// ecPhonePush(BuildContext context) async {
//   NavigatorState state = Navigator.of(context);
//   String u = auth.currentUser!.uid;
//
//   if (FirebaseManager.auth.currentUser != null) {
//     final snapshot = await FirebaseManager.database
//         .ref('Users/${FirebaseManager.auth.currentUser!.uid}')
//         .get();
//     print(snapshot.value);
//     print("User Exists.");
//     if (!snapshot.exists) {
//       print("NULL");
//     }
//   }
//   final snapshot = await FirebaseManager.database.ref('Users/${u}/emergencyContact').get();
//   print(snapshot.key);
//
//   Map<String, dynamic> map = Map<String, dynamic>.from(snapshot.value as Map<dynamic,dynamic>);
//   print(map[u]);
//   Person person;
//   // person = Person.fromJson(map);
//   // print(person);
//   List<String>? exList= [ecPhone1Controller.text,ecPhone2Controller.text];
//   print(exList);
//
//   map = exList as Map<String, dynamic>;
//   print(map);
//
//   // await database.ref('Users/${FirebaseManager.auth.currentUser!.uid}/emergencyContact').update(map);
//   print("Updated in DB");
// }