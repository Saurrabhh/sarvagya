import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sarvagya/utils/auth_utils.dart';
import '../../dataclass/person.dart';
import '../../firebase/firebase_manager.dart';
import '../../utils/text_fileds.dart';

class SignupScreen extends StatelessWidget {

  SignupScreen({super.key});

  final FirebaseAuth auth = FirebaseManager.auth;
  final FirebaseDatabase database = FirebaseManager.database;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  final TextEditingController ecPhone1Controller = TextEditingController();
  final TextEditingController ecPhone2Controller = TextEditingController();

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
                    'SignUp',
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  customTextField("Email", emailController,
                      inputType: TextInputType.emailAddress),
                  customTextField("Name", nameController),
                  customTextField("DOB", ageController,
                      inputType: TextInputType.number),
                  customTextField("Gender", genderController),
                  customTextField("Password", passwordController),
                  customTextField("Phone No.", phoneNoController,
                      inputType: TextInputType.phone),
                  customTextField("Emergency Contact 1", ecPhone1Controller,
                      inputType: TextInputType.phone),
                  customTextField("Emergency Contact 2", ecPhone2Controller,
                      inputType: TextInputType.phone),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {signup(context);},
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.tealAccent),
                      ),
                      child: const Text('SignUp', style: TextStyle(color: Colors
                                  .teal, fontSize: 18),
                                textAlign: TextAlign.center,),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }



  signup(BuildContext context) async {
    NavigatorState state = Navigator.of(context);
    try {
      AuthUtils.showLoadingDialog(context);
      final credentials = await auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if(context.mounted){
        Person person = Provider.of<Person>(context,listen: false);
        person = Person(name: nameController.text, email: emailController.text, age: ageController.text, gender: genderController.text, uid: credentials.user!.uid, emergencyContacts: [ecPhone1Controller.text,ecPhone2Controller.text]);
        await database.ref('Users/${person.uid}').set(person.toJson());
        print("Pushed in DB");
      }
      //Goto Home
      state.pushNamedAndRemoveUntil('home', (Route route) => false);
      print("Redirected to HomePage");
    } on FirebaseAuthException catch (e) {
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
