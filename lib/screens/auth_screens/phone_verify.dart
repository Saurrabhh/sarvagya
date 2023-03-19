import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_borders/gradient_borders.dart';

import '../../dataclass/person.dart';
import '../../utils/auth_utils.dart';

class PhoneVerify extends StatelessWidget {
  PhoneVerify({Key? key}) : super(key: key);

  String verificationIDReceived = "";
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff14122a),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff14122a),
                  Color(0xff13132d),
                  Color(0xff13132f),
                  Color(0xff1b1a3c),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              )
            ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 200,
                  ),
                  Text("Phone No. Verification",style: TextStyle(color: Colors.white,fontSize: 28),),
                  const SizedBox(
                    height: 50,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField (
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.phone,
                      cursorColor: Colors.white,
                      controller: phoneController,
                      decoration: InputDecoration(
                        border:GradientOutlineInputBorder(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Color(0xff13132d),
                              Color(0xff1b1a3c),
                              Color(0xff13132d),
                              Colors.white,
                            ],),
                          width: 5,),
                        labelText: "Phone Number",
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: GradientOutlineInputBorder(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff13132d),
                              Colors.white,
                              Color(0xff13132d),
                            ]
                          ),
                          width: 5
                        ),
                        hintText: "Phone Number",
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),


                 InkWell(
                   onTap:  (){
          verifyNumber(context);
          } ,
              child: Container(
                width: 80,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xff13132d),
                  border: GradientBoxBorder(
                    gradient:LinearGradient(
                      colors: [
                        Color(0xff13132d),
                        Colors.white
                      ]
                    )
                  )
                ),
                child: Text('Verify',style: TextStyle(color: Colors.white,fontSize: 18),textAlign: TextAlign.center,),
              )
                 ),
                ],
              ),

          ),
        ),
      ),
    );
  }


  verifyNumber(BuildContext context) {
    NavigatorState state = Navigator.of(context);

    AuthUtils.showLoadingDialog(context);
    auth.verifyPhoneNumber(
        phoneNumber: phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential).then((value) =>{
            print("You are Logged in.")
          });
        },
        verificationFailed: (FirebaseAuthException e){
          print("Verification Failed");
          Fluttertoast.showToast(
            msg: "Verification Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
          );
          print(e.message);
          state.pop();
        },
        codeSent: (String verifictionID, int? resendToken){
          print("Code Sent");
          verificationIDReceived = verifictionID;
          List<String> data_to_send = [verificationIDReceived,phoneController.text];
          Fluttertoast.showToast(
            backgroundColor: Colors.white,
            textColor: Color(0xff13132d),
            msg: "OTP Sent",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
          );
          print("Redirect to OTP Verification Page");
          state.pushNamedAndRemoveUntil('/verifyOtp',arguments: data_to_send, (Route route) => false);
        },
        codeAutoRetrievalTimeout: (String verificationID){}
    );
  }
}
