import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sarvagya/utils/auth_utils.dart';

import '../../dataclass/person.dart';
import '../../firebase/firebase_manager.dart';
import '../../utils/text_fileds.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final FirebaseAuth auth = FirebaseManager.auth;
  final FirebaseDatabase database = FirebaseManager.database;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.teal,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    'Log In',
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  customTextField("Email", emailController,
                      inputType: TextInputType.emailAddress),
                  customTextField("Password", passwordController),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {logIn(context);},
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.tealAccent),
                      ),
                      child: const Text('Log In', style: TextStyle(color: Colors
                          .teal, fontSize: 18),
                        textAlign: TextAlign.center,),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {Navigator.pushNamed(context, '/signup');},
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.tealAccent),
                      ),
                      child: const Text('Sign Up', style: TextStyle(color: Colors
                          .teal, fontSize: 18),
                        textAlign: TextAlign.center,),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }



  logIn(BuildContext context) async {
    // Person person = Provider.of<Person>(context);
    NavigatorState state = Navigator.of(context);
    try {
      AuthUtils.showLoadingDialog(context);
      final credentials = await auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // final snapshot = await database.ref("Users/${credentials.user!.uid}").get();
      // if(context.mounted){
      //   Person person = Provider.of<Person>(context);
      //   person = Person.fromJson(snapshot.value as Map);
      // }
      print("Redirected to HomePage");
      state.pushNamedAndRemoveUntil('home', (Route route) => false);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found') {
        print("user-not-found");
        Fluttertoast.showToast(
          msg: "No user found for that email.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      } else if (e.code == 'wrong-password') {
        print("wrong-password");
        Fluttertoast.showToast(
          msg: "Wrong password provided for that user.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Enter valid details",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      }
      state.pop();
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
