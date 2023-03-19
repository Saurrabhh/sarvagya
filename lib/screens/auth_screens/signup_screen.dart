import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_borders/gradient_borders.dart';

import '../../dataclass/person.dart';
import '../../firebase/firebase_manager.dart';
import '../../utils/auth_utils.dart';

class SignupScreen extends StatelessWidget {
  final String args;

  SignupScreen({super.key, required this.args});

  final FirebaseAuth auth = FirebaseManager.auth;
  final FirebaseDatabase database = FirebaseManager.database;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ecPhone1Controller = TextEditingController();
  final TextEditingController ecPhone2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff14122a),
      body: SingleChildScrollView(
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
            ),
          ),
          child: Column(
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Text('SignUp',
                      style: TextStyle(color: Colors.white, fontSize: 28),),
                    const SizedBox(
                      height: 30,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                          border: GradientOutlineInputBorder(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Color(0xff13132d),
                                Color(0xff1b1a3c),
                                Color(0xff13132d),
                                Colors.white,
                              ],
                            ),
                            width: 5,
                          ),
                          labelText: "Email",
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
                          hintText: "Email",
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        controller: nameController,
                        decoration: InputDecoration(
                          border: GradientOutlineInputBorder(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Color(0xff13132d),
                                Color(0xff1b1a3c),
                                Color(0xff13132d),
                                Colors.white,
                              ],
                            ),
                            width: 5,
                          ),
                          labelText: "name",
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
                          hintText: "Name",
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        controller: dobController,
                        decoration: InputDecoration(
                          border: GradientOutlineInputBorder(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Color(0xff13132d),
                                Color(0xff1b1a3c),
                                Color(0xff13132d),
                                Colors.white,
                              ],
                            ),
                            width: 5,
                          ),
                          labelText: "DOB",
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
                          hintText: "DOB",
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        controller: genderController,
                        decoration: InputDecoration(
                          border: GradientOutlineInputBorder(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Color(0xff13132d),
                                Color(0xff1b1a3c),
                                Color(0xff13132d),
                                Colors.white,
                              ],
                            ),
                            width: 5,
                          ),
                          labelText: "Gender",
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
                          hintText: "Gender",
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),


                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        controller: passwordController,
                        decoration: InputDecoration(
                          border: GradientOutlineInputBorder(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Color(0xff13132d),
                                Color(0xff1b1a3c),
                                Color(0xff13132d),
                                Colors.white,
                              ],
                            ),
                            width: 5,
                          ),
                          labelText: "Password",
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
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),


                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        controller: ecPhone1Controller,
                        decoration: InputDecoration(
                          border: GradientOutlineInputBorder(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Color(0xff13132d),
                                Color(0xff1b1a3c),
                                Color(0xff13132d),
                                Colors.white,
                              ],
                            ),
                            width: 5,
                          ),
                          labelText: "Emergency Contact 1",
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
                          hintText: "Emergency Contact 1",
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        controller: ecPhone2Controller,
                        decoration: InputDecoration(
                          border: GradientOutlineInputBorder(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Color(0xff13132d),
                                Color(0xff1b1a3c),
                                Color(0xff13132d),
                                Colors.white,
                              ],
                            ),
                            width: 5,
                          ),
                          labelText: "Emergency Contact 2",
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
                          hintText: "Name",
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        signup(context);
                      },
                      child: Container(
                        width: 100,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color(0xff13132d),
                            border: GradientBoxBorder(
                                gradient: LinearGradient(
                                    colors: [
                                      Color(0xff13132d),
                                      Colors.white
                                    ]
                                )
                            )
                        ),
                        child: Text('SignUp', style: TextStyle(color: Colors
                            .white, fontSize: 18),
                          textAlign: TextAlign.center,),
                      ),
                    ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  signup(BuildContext context) async {
    print("Sign-Up");

    NavigatorState state = Navigator.of(context);
    try {
      // Make User from the inbuilt func of Firebase
      final credentials = await auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      List<String>? ecList = [ecPhone1Controller.text, ecPhone2Controller.text];
      // Make object of dataclass and push on DB
      Person person = Person();
      Map<String, dynamic> personJson = {};
      personJson['name'] = nameController.text;
      personJson['uid'] = credentials.user!.uid;
      personJson['email'] = emailController.text;
      personJson['phone'] = args;
      personJson['emergencyContact'] = ecList;

      person.fromJson(personJson);
      print("Person Object Created");

      //Push on DB
      await database.ref('Users/${person.uid}').set(person.toJson());
      print("Pushed in DB");

      //Goto Home
      state.pushNamedAndRemoveUntil('home', (Route route) => false);
      print("Redirected to HomePage");
    }
    on FirebaseAuthException catch (e) {
      print('Error Found');
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
          msg: "The password provided is too weak.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          msg: "An account already exists for that email.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Invalid details",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
        msg: 'Something is Wrong',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    }
  }
}