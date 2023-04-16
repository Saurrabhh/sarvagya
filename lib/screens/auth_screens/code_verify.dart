// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:gradient_borders/gradient_borders.dart';
// import '../../utils/auth_utils.dart';
//
// class verifyOtp extends StatefulWidget {
//   final List<String> args;
//   verifyOtp({Key? key, required this.args}) : super(key: key);
//
//   @override
//   State<verifyOtp> createState() => _verifyOtpState();
// }
//
// class _verifyOtpState extends State<verifyOtp> {
//   final TextEditingController codeController = TextEditingController();
//   late String verificationIDReceived;
//   FirebaseAuth auth = FirebaseAuth.instance;
//   FirebaseDatabase database = FirebaseDatabase.instance;
//
//   @override
//   void initState() {
//     verificationIDReceived = widget.args[0];
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xff14122a),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color(0xff14122a),
//                   Color(0xff13132d),
//                   Color(0xff13132f),
//                   Color(0xff1b1a3c),
//                 ],
//                 begin: Alignment.bottomCenter,
//                 end: Alignment.topCenter,
//               ),
//
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(
//                   height: 100,
//                 ),
//                 Text("OTP",style: TextStyle(color: Colors.white,fontSize: 28),),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25),
//                   child: TextFormField(
//                     style: TextStyle(color: Colors.white),
//                     cursorColor: Colors.white,
//                     keyboardType: TextInputType.number,
//                     controller: codeController,
//                     decoration: InputDecoration(
//                       border: GradientOutlineInputBorder(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.white,
//                             Color(0xff13132d),
//                             Color(0xff1b1a3c),
//                             Color(0xff13132d),
//                             Colors.white,
//                           ],
//                         ),
//                         width: 5,
//                       ),
//                       labelText: "Verification Code",
//                       labelStyle: TextStyle(color: Colors.white),
//                       focusedBorder: GradientOutlineInputBorder(
//                           gradient: LinearGradient(
//                               colors: [
//                                 Color(0xff13132d),
//                                 Colors.white,
//                                 Color(0xff13132d),
//                               ]
//                           ),
//                           width: 5
//                       ),
//                       hintText: "Verification Code",
//                       hintStyle: TextStyle(color: Colors.white70),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 30,
//                 ),
//
//                 InkWell(
//                   onTap: (){
//                     verifyCode(context);
//                   },
//                     child: Container(
//                   width: 80,
//                   padding: EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                       color: Color(0xff13132d),
//                       border: GradientBoxBorder(
//                           gradient:LinearGradient(
//                               colors: [
//                                 Color(0xff13132d),
//                                 Colors.white
//                               ]
//                           )
//                       )
//                   ),
//
//                   child: Text('Verify',style: TextStyle(color: Colors.white,fontSize: 18),textAlign: TextAlign.center,),
//                 ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   verifyCode(BuildContext context) async{
//
//     NavigatorState state = Navigator.of(context);
//     PhoneAuthCredential credential = PhoneAuthProvider.credential(
//       verificationId: verificationIDReceived,
//       smsCode: codeController.text,
//     );
//     AuthUtils.showLoadingDialog(context);
//     await auth.signInWithCredential(credential).then((value) {
//         print("Logged in");
//       },
//     );
//     if(await checkNumberIsRegistered(number: widget.args[1])){
//       print("Already a User, Redirected to Homepage");
//       state.pushNamedAndRemoveUntil('home', (Route route) => false);
//     }
//     else{
//       print("New User, Redirected to SignUp");
//       state.pushNamedAndRemoveUntil('/signup',arguments: widget.args[1], (Route route) => false);
//     }
//
//   }
//
//   Future<bool> checkNumberIsRegistered({required String number}) async {
//     bool isNumberRegistered = false;
//     try {
//       print("TRY");
//       await database.ref("Users").once().then((data) {
//         for (var i in data.snapshot.children) {
//           String data = i.child("phone").value.toString();
//           print(data);
//           if (number == data) {
//             isNumberRegistered = true;
//             return isNumberRegistered;
//           } else {
//             isNumberRegistered = false;
//           }
//         }
//       });
//       return isNumberRegistered;
//     } catch (e) {
//       return false;
//     }
//   }
//
// }
